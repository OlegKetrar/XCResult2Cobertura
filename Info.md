

// get list of abs filepaths from report
xcrun xccov view --archive --file-list <report>.xcresult


// write lineCoverage for file to json
xcrun xccov view 
  --archive 
  --file <filepath> 
  --json 
  <report>.xcresult > <output>.json
