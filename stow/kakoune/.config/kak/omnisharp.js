const cp = require('child_process');
const {
  ensureFifo,
  readFifo,
  writeFifo,
  byLine
} = require('./utilities');


const getHostDir = msg => {
  const hostDir = process.env['kak_opt_omnisharp_host_tmp_dir'];
  if (hostDir == null || hostDir === '') {
    process.stdout.write(msg);
    process.exit(1);
  }
  return hostDir;
};

const outputLoop = (hostDir, child) => {
  ensureFifo(hostDir + '/out');
  byLine(child.stdout, line => {
    try {
      const data = JSON.parse(line);
      if (data['Request_seq'] === 455) {
        process.stdout.write('== OUT ==\n'+ line + '\n');
        writeFifo(hostDir + '/out', line);
      } else {
        process.stdout.write('== CHILD ==\n'+ line + '\n');
      }
    } catch (e) {
      process.stderr.write(e.toString());
    }
  });
};

const inputLoop = (hostDir, child) => {
  readFifo(hostDir + '/in', raw => {
    process.stdout.write('== IN ==\n'+ JSON.stringify(raw) + '\n');
    const request = { ...raw, seq: 455 };
    child.stdin.write(JSON.stringify(request) + '\n');
    inputLoop(hostDir, child);
  });
};

module.exports = (data, cb) => {
  const hostDir = getHostDir('echo -markup "{Error}omnisharp host not running"');
  readFifo(hostDir + '/out', cb);
  writeFifo(hostDir + '/in', data);
};

if (require.main === module) {
  const hostDir = getHostDir('omnisharp host dir not set');
  const child = cp.spawn('omnisharp', process.argv.slice(2), {
    stdio: [ 'pipe', 'pipe', process.stderr ]
  });
  child.on('close', code => process.exit(code));
  process.on('SIGINT', () => process.exit(0));
  process.on('SIGTERM', () => process.exit(0));
  process.on('exit', () => child.kill());
  outputLoop(hostDir, child);
  inputLoop(hostDir, child);
}

