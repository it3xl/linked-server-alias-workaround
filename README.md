# Workaround for dynamic aliasing of Linked Servers in MS SQL Server

Microsoft SQL server doesn't allow you to have a reference to a linked server or a dynamic alias.
This is an infamous feature and view of Microsoft, for decades. There are no aliases for server-level objects.

> If all your environments (dev, test, UAT, production) has only one linked server.<br/>
> It is better to use named linked servers. Convert your existing linked server name [MyServer\MyInstance] to a common name [MyLinkedServer], which will refer to different SQL Server instances on different environments.

The workaround can overcome:
* Need to pass a name of a linked server as a parameter to a stored procedure.
* Store linked server name in a variable to modify and invoke it dynamically.
* Need to interact with hundreds of tables and views. Using of use other approaches from over the Internet (listed below) will cause complications.

This technique will allow your team to retain straightforward, standard and well-known development.<br/>
But, you will look on things from another side, thanks for Microsoft.

I call it Permanent Scaffolding.

## How to use

~ Create all linked servers you need.<br/>
You may have only one primary linked server on dev- and test stands.

~ Create an initial stored procedure to use the primary linked server.

~ Install the [CloneSP](https://github.com/it3xl/linked-server-alias-workaround/blob/master/CloneSP.sql) stored procedure on your database.

~ During a deployment process create a cloned stored procedures for each other linked servers as the example shows in the [try-me-after-install-CloneSP.sql](https://github.com/it3xl/linked-server-alias-workaround/blob/master/try-me-after-install-CloneSP.sql).
```sql
EXECUTE CloneSP
  @source_name = '[dbo].[MySampleSP]',
  @target_name = '[dbo].[MyClonedSP]',
  
  @sub1_from = 'Server_level_alias__Linked_server',
  @sub1_to = 'Replaced_alias__Other_linked_server',
  
  @sub2_from = 'MySampleSP',
  @sub2_to = 'MyClonedSP'
;
```

~ Use the cloned stored procedure where the first procedure is used.

~ Use your brain for others stuff. Or ask me if any troubles.

## How it works

~ Look at an example of usage in the [try-me-after-install-CloneSP.sql](https://github.com/it3xl/linked-server-alias-workaround/blob/master/try-me-after-install-CloneSP.sql)

## Disadwantages of the current solution

* It forces you to create a huge stored procedures. For small procedures you have to run CloneSP more often and you can forget something that was recently added.

## Other solutions

* Generating stored procedures outside of SQL Server (as an example, during the deployment process).

* Dynamic aliases on linked-server objects (created in a loop). Aka aliases on target objects as MyLinkedServer.MyDb.dbo.MyTable

No fast switching.<br/>
Pain for huge codebase.<br/>
More error prone and tough supporting.

* A network alias switching

It blocks various automation.<br/>
There is no exact point in the time of the switching.<br/>

* Dynamic SQL

This is more error prone approach.<br/>
Expensive support even for middle level databases.<br/>
Debug and development pain.<br/>
