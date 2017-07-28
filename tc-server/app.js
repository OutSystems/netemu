const express = require("express");
const app = express();
const swig = require("swig");
const index_template = swig.compileFile('index.html');
const child_process = require("child_process");

const PORT = 3000;

var state = { status: "wifi", lastOut: "" };

function execTC(netkind) {
    var result = child_process.execSync('sudo "' + __dirname + '/tc-set.sh" ' + netkind + ' 2>&1');
    state.lastOut = (result || "").toString();
}

app.get("/", function(req, res) {
    var output = index_template({
        status: state.status,
        lastOut: state.lastOut,
    });
    res.send(output);
});

app.get("/setnetwork/:netkind", function (req, res) {
    state.status = req.params.netkind;
    execTC(req.params.netkind);
    res.redirect("/");
});

app.listen(PORT, function() {
    console.log("resetting TC");
    execTC("wifi");
    console.log(`Listening on port ${PORT}`);
});
