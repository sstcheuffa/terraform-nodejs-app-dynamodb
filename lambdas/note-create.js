const AWS = require("aws-sdk"); // using the SDK
const NOTES_TABLE = process.env.NOTES_TABLE; // obtaining the table name

const documentClient = new AWS.DynamoDB.DocumentClient();

module.exports.handler = async (event, context) => {
 // create a new object

 const my_body = event.body;
 const newNote = {
    body: event.body,
    noteId: (Date.now()).toString(),
    expiryPeriod: Date.now(), // specify TTL
 };
  
 // insert it to the table

 await documentClient
   .put({
     TableName: NOTES_TABLE,
     Item: newNote,
    })
   .promise();
    
 // return the created object

 return {statusCode: 200, body: JSON.stringify(newNote), table: NOTES_TABLE
 }; 
};