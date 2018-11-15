const fs = require('fs');
const childProcess = require('child_process');


const tryParse = data => {
  try {
    return JSON.parse(data);
  } catch(e) {
    return undefined;
  }
};

const onJsonLine = (stream, cb) => {
  let data = '';
  stream.setEncoding('utf8');
  stream.on('data', chunk => {
    try {
      for (var i = 0; i< chunk.length; i++) {
        if (chunk[i] == '\n') {
          cb(tryParse(data));
          data = '';
        } else {
          data += chunk[i];
        }
      }
    } catch (e) {
      process.stderr.write(e.toString());
    }
  });
};

const host = () => {
  const child = childProcess.execFile('omnisharp', process.argv.slice(2));
  onJsonLine(process.stdin, msg => {
    if (msg == null) return;
    msg['seq'] = 455;
    child.stdin.write(JSON.stringify(msg)+'\n');
  });
  onJsonLine(child.stdout, msg => {
    if (msg == null) return;
    var seq = msg['Request_seq'];
    if (seq != null && seq === 455) {
      process.stdout.write(JSON.stringify(msg)+'\n');
    }
  });
  child.stderr.pipe(process.stderr);
  child.on('close', code => process.exit(code));
  process.on('SIGINT', () => process.exit(0));
  process.on('SIGTERM', () => process.exit(0));
  process.on('exit', () => child.kill());
  return child;
};

const request = (hostDir, body, cb) => {
  if (hostDir == null || hostDir === '') {
    process.stdout.write('echo -markup "{Error}omnisharp host not running"');
    process.exit(0);
  }
  const rs = fs.createReadStream(hostDir + '/out', 'utf8');
  onJsonLine(rs, response => {
    rs.destroy();
    cb(response);
  });
  const ws = fs.createWriteStream(hostDir + '/in', 'utf8')
  ws.write(JSON.stringify(body) + '\n');
  ws.end();
};

module.exports = request;

if (require.main === module) host();
