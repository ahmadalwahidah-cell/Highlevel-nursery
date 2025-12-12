// Test to understand the issue
const test1 = `SELECT * FROM attendance WHERE student_id = 1`;
const test2 = `SELECT date, status FROM attendance WHERE student_id = 1`;
const test3 = `SELECT * FROM attendance LIMIT 2`;

console.log("Query 1 (works in wrangler):", test1);
console.log("Query 2 (should work):", test2);
console.log("Query 3 (works in debug):", test3);

// Check if there's a difference
console.log("\nTesting bind vs template:");
console.log("Template:", `SELECT * FROM attendance WHERE student_id = ${1}`);
console.log("Bind should be:", "SELECT * FROM attendance WHERE student_id = ?");
