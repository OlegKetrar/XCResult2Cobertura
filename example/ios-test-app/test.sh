#! /bin/sh

device_name="iPhone 12"
derivedDataPath=".DerivedData"
report_dir="build/reports"
xcresult_path="${report_dir}/coverage.xcresult"
xcov_json_path="${report_dir}/coverage.json"
cobertura_path="${report_dir}/cobertura.xml"
junit_path="${report_dir}/junit.xml"

rm -rf "$derivedDataPath"
rm -rf "$report_dir"

# set -o pipefail && 

xcodebuild \
  ONLY_ACTIVE_ARCH=YES \
  -project ios-test-app.xcodeproj \
  -scheme ios-test-app \
  -testPlan unit-tests \
  -sdk iphonesimulator \
  -destination "platform=iOS Simulator,name=$device_name" \
  -configuration Debug \
  -scmProvider system \
  -derivedDataPath "$derivedDataPath" \
  -enableCodeCoverage YES \
  -resultBundlePath "$xcresult_path" \
  test

result=$?

if [[ $result -eq 0 ]]; then
  coverage_value=$(xcrun xcresulttool get --format json --path "$xcresult_path" | jq -r '.metrics.totalCoveragePercentage._value')
  coverage_value=$(echo $coverage_value \* 100.0 | bc)
  coverage_value=$(printf "%.2f" $coverage_value)

  echo "Coverage: $coverage_value %"

  xcrun xccov view --report --json "$xcresult_path" > "$xcov_json_path"
  xcc generate "$xcov_json_path" "$report_dir/" cobertura-xml
fi

exit $result
