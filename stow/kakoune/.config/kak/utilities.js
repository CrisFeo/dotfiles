const cp = require('child_process');
const fs = require('fs');


module.exports.ensureFifo = path => {
  if (!fs.existsSync(path)) cp.execSync('mkfifo "' + path + '"');
};

module.exports.readFifo = (path, cb) => {
  module.exports.ensureFifo(path);
  return cp.exec('cat "'+ path + '"', (err, stdout, stderr) => {
    try {
      process.stderr.write(stderr);
      cb(JSON.parse(stdout));
    } catch (e) {
      process.stderr.write(e.toString());
    }
  });
};

module.exports.writeFifo = (path, data) => {
  module.exports.ensureFifo(path);
  var s = fs.createWriteStream(path);
  if (typeof data !== 'string') data = JSON.stringify(data);
  s.write(data);
  s.close();
};

module.exports.byLine = (stream, cb) => {
  var buffer = '';
  stream.on('data', data => {
    try {
      process.stdout.write('chunk: '+data+'\n');
      buffer += data;
      const lines = buffer.split(/[\n|\r\n]/);
      buffer = lines.pop();
    	lines.forEach(cb);
    } catch (e) {
      process.stderr.write(e.toString());
    }
  });
  stream.on('end', () => {
    try {
      if (buffer.length > 0) cb(buffer);
    } catch (e) {
      process.stderr.write(e.toString());
    }
  });
}
