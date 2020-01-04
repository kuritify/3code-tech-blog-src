const aws = require('aws-sdk');
//const yaml = require('js-yaml');
const { yamlParse } = require('yaml-cfn');
const fs   = require('fs');
const path = require('path');
const util = require('util');

(async() => {
  try {
    const ddb = new aws.DynamoDB(
        { endpoint: new aws.Endpoint('http://localhost:8000') }
    );

    let doc = yamlParse(fs.readFileSync(path.resolve(__dirname, '..', 'template.yaml')));
    Object.keys(doc.Resources).forEach(async (each) => {
      if (doc.Resources[each].Type !== 'AWS::DynamoDB::Table') return;
      let params = doc.Resources[each].Properties;
      convertCf(params, each, params);
      let result = await ddb.createTable(params).promise();
      console.log(result);
    });
  } catch (e) {
    console.error('errrrrrrrrr', e);
  }
})();

function convertCf(param, _key, parentParam) {
  if (typeof param !== 'object') return;
  
  if (Array.isArray(param)) {
    for (let a of param) {
      return convertCf(a, _key, param);
    }
  } else {
    Object.keys(param).forEach((key) => {
      if (typeof param[key] === 'object') {
        return convertCf(param[key], key, param);
      } else {
        //   { TableName: { 'Fn::Sub': 'orevia-${ProjectName}-${Environment}' },
        if (key === 'Fn::Sub') {
          let newValue = param[key];
          param[key].match(/[$][{]([^}]+)[}]/g).forEach((matched) => {
            const env = matched.replace(/[${}]/g,"");
            if (!process.env.hasOwnProperty(env)) {
              throw new Error(`${env} is not definid on environment variablse`);
            }
            newValue = newValue.replace(matched, process.env[env]);
          });
          parentParam[_key] = newValue;
        }
      }
    });
  }
}
