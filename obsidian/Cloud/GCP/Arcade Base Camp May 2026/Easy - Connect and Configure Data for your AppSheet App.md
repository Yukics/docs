## Task 1. Copy the app

When working on your own or your company's app, you normally would incrementally build the app over a continuous project timeline.

In order to continue building the app in this lab environment, you must first copy the app that was previously built in the previous lab.

### Copy the app to your AppSheet account

1. Open the link in another browser tab to copy the _Customer Contacts_ app to your AppSheet account: [Customer Contacts app](https://www.appsheet.com/Template/AppDef?appName=Lab1-CustomerContacts-3856613).
    
2. Click **Copy app** from the left pane.
    
3. On the **Copy App** form, specify the following, and leave the remaining settings as their defaults:
    
    |   |   |
    |---|---|
    |**App name**|Customer Contacts|
    
4. Click **Copy app**.
    
    You can also access the app from the **My apps** page in the AppSheet UI under **Apps**.
    

Your app is set up with the original contacts data source, and you can now continue to build out the app's functionality.

Click _Check my progress_ to verify the objective.

Create the app

## Task 2. Set up your app with a second data source

Our _Customer contacts_ app currently uses a Google sheet containing sample person contact information.

In this task, you add a second Google sheet that contains information about companies to the app.

### Select data for your app

AppSheet refers to data files used in your app as tables. A table is a description of the rows and columns in your spreadsheet. While all of the data is stored in your spreadsheet, this description becomes part of your app definition.

Adding a table to your app is usually one of the first steps involved in creating an app.

To add additional tables after you have created your app, perform the following steps:

1. Copy and paste the link below in a separate browser tab: [A copy of companies](https://docs.google.com/spreadsheets/d/1fsusJTqRwsURG9GpduXVZE8XXfv9vzq5XXI9jBlcq9M/copy).
    
2. Click **Make a copy** to make a copy of the spreadsheet in your Google drive folder.
    
3. At the top left corner of the sheet, click anywhere in the filename and change the name to **companies**.
    
    ![The companies sheet](https://cdn.qwiklabs.com/X9IrAslVsjARp0IfgEf6dHXva1Q9qx29OVXPudqg3og%3D "companies sheet")
    
4. Navigate to [drive.google.com](https://drive.google.com/) to confirm the file has been saved to your **My Drive** folder.
    
    ![my drive data](https://cdn.qwiklabs.com/zk0E%2Bj01gcaaDOZaptJhq%2BTBi%2BO4VbGyxdYeXbaHMd0%3D "my drive data")
    
5. In the _Customer Contacts - AppSheet_ UI, use the left navigation bar and go to **Data > Contacts**.
    
    ![The contacts table listed on the Tables tabbed page](https://cdn.qwiklabs.com/3N%2F2CzibyZeJC7UD5VmfQqPuMFJwEcbZT1HjMKrPiW0%3D "add new table")
    
6. To add a second data source to your app, click **Add new Data** (+) next to `Data`.
    
7. In **Add data** form, select **Google Sheets**.
    

If you get an error preventing you from adding new data, please refresh the page then try to **Add data** again.

8. In the file picker, select the **companies** sheet that you uploaded in the previous step and click **Select**.
    
9. In the **Create a new table** form, leave the default settings and click **Add 1 table**.
    
    The settings in this dialog allow you to select a specific worksheet from the spreadsheet or a different type of data source; and lets you allow or disallow modifications to the data by users of the app.
    
    **Note:** The AppSheet editor only recognizes one table per worksheet. If you have multiple tables in the same worksheet, you'll need to move tables to new tabs in the workbook or Google sheet.
    

AppSheet adds the _companies_ table to your app. This table contains information about various sample companies.

10. Preview the data from the new table using the app live preview feature in AppSheet.
    
    ![The companies table preview](https://cdn.qwiklabs.com/eD3JBq7RwG%2F1IigFuKUAFHd1Vhsa7xyD4WW2VZ5Etgw%3D "preview companies table")
    

Click _Check my progress_ to verify the objective.

Set up your app with a second data source

## Task 3. Configure your app's data structure

When a data source is added as a table for your app, AppSheet reads each column header to define the column structure of the app. You need a column header in your data source for each column in which you store data.

In this task, you inspect and if needed update the columns' type and properties (the default structure) that AppSheet has inferred and set for the app.

### Update column structure for: _contacts_

1. In the AppSheet editor left navigation menu, select **Data**.
    
2. To inspect the structure of the columns in the _contacts_ table, click the **contacts**.
    
    ![The contacts panel](https://cdn.qwiklabs.com/%2B9O9OKZmGiu4M%2FMeZKGCgzP9M%2FRcO49fG021GLAL0%2Fg%3D "view contacts table columns")
    

The table below lists the columns and some of their properties as inferred by AppSheet.

3. Determine if you need to change the type or other properties of each column (Scroll to the right in the AppSheet editor to view all the column properties).
    
    |   |   |   |   |   |   |   |   |
    |---|---|---|---|---|---|---|---|
    |**Name**|**Type  <br>**|**Key?  <br>**|**Label?  <br>**|**Formula  <br>**|**Show?  <br>**|**Editable?  <br>**|**Require?  <br>**|
    |_RowNumber  <br>(System generated virtual column)|Number|||||||
    |ID|Number|checked|||checked|checked|checked|
    |Email Address|Email||||checked|checked|checked|
    |First Name|Name||||checked|checked|checked|
    |Last Name|Name||||checked|checked||
    |Phone|Text||||checked|checked||
    |_ComputedName  <br>(System generated virtual column)|Name||checked|CONCATENATE([First Name]," ",[Last Name])|checked|||
    
    Which of the above columns' properties do you think needs to be updated?
    
    This generally depends on your app's requirements. For the purposes of this lab, the highlighted columns in the table above are candidates whose properties should be changed.
    
4. Given that this is a person contact app, there must be valid data in all cells of the _First Name_ column, so the **Require?** property for this column should be checked.
    

Notice that AppSheet has set the _type_ property of the **Phone** column as _text_.

This allows the column to contain a single line of text. Since this column is intended to store a valid phone number, change the type to **Phone** using the drop-down list.

5. Click **SAVE** to save your column configuration changes.

### Update column structure for: _companies_

Follow the same process to update the structure of the columns of the _companies_ table, where required.

1. Perform this step by referring to the highlighted items in the table below as a guide to update the column properties:
    
    |   |   |   |   |   |   |   |   |
    |---|---|---|---|---|---|---|---|
    |**Name**|**Type  <br>**|**Key?  <br>**|**Label?  <br>**|**Formula  <br>**|**Show?  <br>**|**Editable?  <br>**|**Require?  <br>**|
    |_RowNumber  <br>(System generated virtual column)|Number|||||||
    |ID|Number|checked|||checked|checked|checked|
    |Phone|Text||||checked|checked|checked|
    |Company Name|Name||||checked|checked|checked|
    |Industry|Text||||checked|checked|checked|
    |Business Address|Address||||checked|checked|checked|
    |Shipping Information|LongText||checked||checked|checked||
    
2. Repeat the previous step for each of the highlighted columns in the table above, except the _Industry_ column which is updated in the next step.
    

AppSheet supports the _Enumerated Type_ for columns. Columns of these types are constrained to having one or more allowed values from a fixed list. In this step, you change the **Industry** column's _type_ property to use the _Enum_ (single value) or _EnumList_ (multiple values) type.

1. Click the pencil icon to the left of the _Industry_ column.
    
    ![The pencil icon highlighted in the UI](https://cdn.qwiklabs.com/H48XA0gmH%2BakXGSARClmVLKTR2SGiSuMwnm2LtGw734%3D "edit industry column")
    
2. On the column details form, specify the following, and leave the remaining settings as their defaults:
    
    |   |   |
    |---|---|
    |**Property**|**Value**  <br>(type or select)|
    |Type|Enum|
    |Type Details<br><br>Values|Accounting<br><br>Finance<br><br>Healthcare<br><br>Retail<br><br>Travel and Hospitality|
    
3. Click **Add** for each enum value to be added to the list of allowed values.
    
    **Note: For information only**
    
    The **Allow other values** option enable users to enter any value they wish in addition to the allowed values displayed in the dropdown list.
    
    The **Auto-complete other values** option makes it easier for the user to choose from the set of previously entered values and helps to ensure that all entries are submitted in the same way avoiding typos.
    
    By setting the **Input mode**, you can control whether the values are displayed as buttons arranged naturally or as a vertical stack, or as a dropdown set of radiobuttons in the app.
    
4. After all the values are entered, click **Done** in the form.
    
5. Click **SAVE** to save the app configuration changes.
    

### Preview the changes in the app for: _companies_

To preview the changes in the AppSheet editor, you create a view for the _companies_ data.

1. In the AppSheet editor, navigate to **App** (![app](https://cdn.qwiklabs.com/yss%2B8g4wGSDZ8Hxqe91HPy%2BUisGSEkVaGNGMxf9zGeU%3D)), and click **Views** (![view](https://cdn.qwiklabs.com/bZGcg6BdR%2FIEcRqcjJ7vheSR0HnB%2F7BBYGVn0kbHXDg%3D)).
    
2. To add a new view for **Primary navigation**, click **+**.
    
3. In the **Add a new view** form, click **Create a new view**. Specify the following, and leave the remaining settings as their defaults:
    
    |   |   |
    |---|---|
    |**Property**|**Value** (type or select)|
    |**View name**|companies|
    |**For this data**|companies|
    
4. To save the new view, click **Save**.
    
5. Preview the change in the live app preview:
    

- Select the `companies` table, and select any one of the company cards from the view.
    
- On the company detail page, to edit the company record, click the pencil.
    
    ![The company, Cymbal Bank, and their information, as well as the pencil icon highlighted in the live app preview](https://cdn.qwiklabs.com/w7K1iVowZVftRG7Ef33zmzb9lVM55ajk4q99ClitfAI%3D "edit a company in the live app preview")
    
- Scroll to select the **Industry** column using the drop-down. The **enum** values are displayed. Select any of the values.
    
    ![The list of industry values with the Finance value selected](https://cdn.qwiklabs.com/ohHq7t0AMG2PCEfkKEnEiy7zDWj5Vp2PCkqYO95Cneg%3D "select industry")
    
- Click **Save** to save the data changes.
    

For more information, refer to the [Column data types documentation](https://help.appsheet.com/en/articles/1013271-column-types-diving-deeper).

## Task 4. Regenerate your app's data structure

AppSheet reads column metadata from your data source to define the column structure of the app. For spreadsheets, AppSheet uses the column headers to derive this information. Every time you modify the columns in the spreadsheet, you need to regenerate the column structure within the app, or AppSheet won't know how to locate the columns to read and write data and your app will stop functioning.

In this task, you regenerate your app's data structure after adding a new column to the sheet on Google drive.

### Add a new column to the _contacts_ sheet

1. Open a browser tab and navigate to [Google drive](https://drive.google.com/). If you already have it open then switch to that tab.
    
2. In Google drive, open the `appsheet/data` folder, by double-clicking _appsheet_ then double-clicking _data_.
    
3. Open the _CustomerContacts-NNNNNNN_ folder.
    
    **Note:** The actual folder name contains numeric digits represented by NNNNNNN.
    
4. Open the _contacts_ sheet.
    
5. Add a new column header in row 1, column F with a value of: **Last Contacted**.
    
    We will use this new column to store the last contacted date and time when the person was contacted.
    
    ![The Last Contacted column highlighted in the sheet](https://cdn.qwiklabs.com/wKVFy%2Blokd2yLEE2EvG7v1oa8PqX09OZPFFCPrlH5OU%3D "adding a last contacted column")
    
6. Switch to the AppSheet editor in your browser and navigate to **Data > contacts**.
    
7. Click **More**(three dots) of the contacts tile and then select **Regenerate Schema**.
    
8. Click **Regenerate** to confirm.
    
    AppSheet regenerates the column structure for the _contacts_ table, and re-syncs the app in the live preview.
    

AppSheet also infers the type of the new column which may not be the intented column type.

9. Using the **Type** dropdown list, change the type of the _Last Contacted_ column to **DateTime**.
    
10. Since it is not mandatory for every contact to have a value for this column, scroll the column properties to the right and verify that the **Require?** property is unchecked. If checked, then select it to uncheck the property.
    
11. Click **SAVE** to save your app configuration changes.
    

### Preview the new column in the app

1. In the app live preview, select one of the contacts from the list.
    
2. Click the pencil icon to edit the contact.
    
3. Scroll to the bottom and click the calendar icon to set the _Last Contacted_ value for the contact.
    
4. Click **Save** in the app preview to save the data for this contact.
    
5. View the _contacts_ sheet on Google drive to verify that the contact that was updated using the app reflects the updated value in the _Last Contacted_ column.
    

Click _Check my progress_ to verify the objective.

Regenerate your app's data structure

## Task 5. Create relationships between tables

The person contacts in the _contacts_ sheet are likely employed at the companies whose information is stored in the _companies_ sheet.

This implies that there is a relationship between the two tables. Appsheet allows you to define references between rows in related tables using a special column type called **Ref**.

In this task, you use the **Ref** column type to define the relationship between rows in the two tables.

Read the AppSheet documentation to learn more about the [Ref column type](https://help.appsheet.com/en/articles/961426-references-between-tables).

### Set up the reference column in the _contacts_ sheet

1. In the _contacts_ sheet on Google drive add a new column header in row 1, column G with a value of: **Company ID**.
    
    This new column will be used to store the ID of the company that the contact is associated with.
    
    ![The Company ID column highlighted on the sheet](https://cdn.qwiklabs.com/1yFe5u8ExLcdkCTXUJTIFzKSripZ2n3gXHzVH7KyvFY%3D "adding the Company ID column")
    
2. Switch to the AppSheet editor in your browser and navigate to **Data > Contacts**.
    
3. Click **More**(three dots) of the contacts tile and then select **Regenerate Schema**.
    
4. then Click **Regenerate** to confirm. AppSheet regenerates the column structure of the _contacts_ table and adds the new _Company ID_ column to the list of columns.
    
5. Click the pencil icon to the left of the _Company ID_ column to edit its properties.
    
6. On the column details form, specify the following, and leave the remaining settings as their defaults:
    
    |   |   |
    |---|---|
    |**Property**|**Value**  <br>(type or select)|
    |Type|Ref|
    |Source table|companies|
    
    This changes the type of the column to be a _reference_ that refers to the _companies_ table.
    
    When contacts are added or updated in the app to include the company that is associated with the contact, AppSheet automatically stores the Company ID in this column in the _contacts_ sheet.
    
7. Since the value displayed in the app for this column is the actual company name, you should change the display name of the column. To do this, scroll down in the same form and expand the **Display** section. Then, click the expression assistant icon in the **Display name** field.
    
8. In the **Expression Assistant** form for **Display Name expression for column Company ID (Text)**, type **Company**.
    
9. Click **Save** in the expression assistant form.
    
10. Click **Done** to save the changes to the column properties.
    
11. Finally, click **Save** in the AppSheet editor to save the changes and refresh the app in the live preview.
### Preview the _Company_ column in the app

13. In the app live preview, select one of the contacts from the _contacts_ list.
    
14. Click the pencil icon to edit the contact.
    
15. Scroll to the bottom and select a _Company_ from the drop-down list of companies. AppSheet has automatically populated the list from the _companies_ table.
    
16. Click **Save** in the app preview to save the data for this contact.
    
17. View the _contacts_ sheet on Google drive to verify that the contact that was updated using the app, contains the ID of the company that was selected.