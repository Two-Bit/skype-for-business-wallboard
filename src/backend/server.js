var express = require("express");
var app = express();
var sql = require("mssql");
var bodyParser = require("body-parser");

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(function(req, res, next) {
  res.setHeader("Access-Control-Allow-Origin", "*");
  res.setHeader("Access-Control-Allow-Methods", "GET, POST");
  res.setHeader(
    "Access-Control-Allow-Headers",
    "X-Requested-With,content-type, Authorization"
  );
  next();
});

// SQL Server configuration

var config = {
  server: "",
  database: "",
  authentication: {
    type: "default",
    options: {
      userName: "",
      password: ""
    }
  }
};

async function ExecuteSQL(query) {
  return new Promise((resolve, reject) => {
    new sql.ConnectionPool(config)
      .connect()
      .then(pool => {
        return pool.request().query(query);
      })
      .then(result => {
        resolve(result.recordset);
        sql.close();
      })
      .catch(err => {
        reject(err);
        sql.close();
      });
  });
}

app.post("/getAgents", (req, res) => {
  let workflow = req.body.params.workflow;
  let query = `EXEC [GET_AGENT_CALLS] '${workflow}'`;
  ExecuteSQL(query).then(result => res.send(result)) 
});

app.post("/getOverall", (req, res) => {
  let workflow = req.body.params.workflow;
  let query = `EXECUTE [GET_OVERALL_CALL_STATS] '${workflow}'`;
  ExecuteSQL(query).then(result => res.send(result)) 
});

app.get("/getList", (req, res) => {
  let query = `EXECUTE [GET_CALLS_TODAY]`;
  ExecuteSQL(query).then(result => res.send(result)) 
});

app.listen(3001, () => console.log("Server is running.."));
