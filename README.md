# Skype For Business Enterprise Call Centre Wallboard

## What is it ?
A React Web application that interfaces with the Microsoft Skype For Business SQL Database to show call statistics from users within a workgroup. 

## What is the use case ?
This app is designed for Enterprises that use the Microsoft Office Suite and Skype For Business as the communications medium, a cost effective alternative to ISDN telephone systems. Using the Skype For Business data, we can draw out the call stats and build relevent metrics for Managers to review (calls per day, average call duration, etc). Rather than spend thousands on Call Centre Software subscriptions, we can use this application.  


## What YOU need to do
1. You will need to setup a database on the server your SFB Database is located, database is called LcsCDR and LcsLog. In our case I created a database and named it MIRA. 
DO NOT use the LcsCDR or LcsLog databases for your own personal views and SPs as they can get removed from Microsoft updates. 

2. When you have set the database, run the queries in the /database/ folder to create the views and stored procedures. 

3. You will also need a table that includes all of your Skype Workflows (Emails tied to groups and agents). This can be found in another separate database rgsconfig, alternatively you can add them in yourself. this is the WB_Workflows table, Created empty in step 2.

4. Run npm start from the root folder, then run node server.js from the backend folder. 

5. The web app should start up in your localhost, it may or may not display any data depending on whether your skype for business databases have been setup consistently with the way we have done it (should be the microsoft standard way).

## Available Scripts

### `npm start`
To start the front end you can run npm start in the root "\\skype-wall-board\" directory 

### `node server.js`
To start the backend server you can open a separate terminal and execute the following "node  .\src\backend\server.js" 

### `npm run build`
To Build the package so you can deploy it

