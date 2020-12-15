
const t1 = Date.now();

const sn = [18,8,0,5,4,1,20];
const t = new Map();
let tn, n, p, a, i = 0;

while (i < sn.length) {
    i++;
    n = sn[i-1];

    tn = t.get(n);
    a = tn ? i - tn : 0;
    t.set(n, i);
    p = n;
}

while (i < 30_000_000) {
    i++;
    n = a;

    tn = t.get(n);
    a = tn ? i - tn : 0;
    t.set(n, i);
    p = n;
}

console.log(`Starting numbers ${sn}, turn ${i} number ${n}`);
console.log("Time: ", Date.now() - t1);
