const express = require("express");
const fileUpload = require("express-fileupload");
const app = express();
const path = require("path");
const { exec } = require("child_process");

app.use(fileUpload({
  createParentPath: true,
  useTempFiles: true,
  tempFileDir: "/tmp/"
}));

app.post("/upload", (req, res) => {
  if (!req.files || Object.keys(req.files).length === 0) {
    return res.status(400).send("No files were uploaded.");
  }

  let audioFile = req.files[Object.keys(req.files)[0]];
  let savePath = "lora_recording.m4a";
  console.log("SavePath: ", savePath);

  audioFile.mv(savePath, function (err) {
    if (err) {
      console.error("File move error:", err);
      return res.status(500).send(err.message);
    }
    const matlabDirectory = "/Users/stuart/Group-15-LoRa-Modulation/api_code/";
    const command = `matlab -batch "cd('${matlabDirectory}'); binary_lora_converter(); exit;"`;
    // const command = `matlab -batch "disp('Hello from MATLAB');"`;
    // console.log("Executing command:", command);
    exec(command, (error, stdout, stderr) => {
      if (error) {
        console.error(`exec error: ${error}`);
        return res.status(500).send(`Error during demodulation: ${stderr}`);
      }

      res.status(200).send(`Demodulated binary data: ${stdout}`);
    });
  });
});

const port = 3000;
app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});
