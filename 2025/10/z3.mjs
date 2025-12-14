import fs from 'fs';
import { init } from 'z3-solver';

let { Z3 } = await init();
let config = Z3.mk_config();
let ctx = Z3.mk_context_rc(config);
let result = await Z3.eval_smtlib2_string(
    ctx,
    fs.readFileSync(0).toString()
);
console.log(result);
