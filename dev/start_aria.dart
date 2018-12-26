import 'dart:io';

Future main() async {
  final uri = Uri.parse(Platform.script.path).resolve('.');
  await clean(uri);
  await runAria(uri);
}

Future runAria(Uri dir) async {
  final inputFile = dir.resolve('linux_distros.txt');
  final cmd = await Process.start('aria2c', [
    '--dir=${dir.toFilePath()}',
    '--file-allocation=none',
    '--enable-rpc',
    '--rpc-secret=passu',
    '--max-download-limit=1M',
    '--max-upload-limit=1M',
    '--download-result=hide',
    '--input-file=${inputFile.toFilePath()}'
  ]);

  try {
    stdout.addStream(cmd.stdout);
    stderr.addStream(cmd.stderr);

    await cmd.exitCode;
  } catch (ex) {
    cmd.kill();
  }
}

Future clean(Uri url) async {
  final dir = await Directory.fromUri(url).list().toList();
  await Future.wait(dir.where(removableFile).map((f) => f.delete()));
}

bool removableFile(FileSystemEntity file) {
  final filename = file.uri.pathSegments.last;
  return filename.startsWith('ubuntu') || filename.startsWith('xubuntu');
}
