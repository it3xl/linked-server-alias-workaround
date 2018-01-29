# Workaround for aliasing on Linked Servers in SQL Server

The Permanent Scaffolding is the main idea.

Microsoft SQL server doesn't allow you to have a reference to a linked server or an alias.
This is an infamous feature and view of Microsoft, for decades. There are no aliases for server-level objects.

> If your environment has only one linked server.
> It is better to use named linked servers. Convert your existing linked server name [MyServer\MyInstance] to a plain name [MyLinkedServer], which refers to different SQL Server instances on different environments (dev, test, UAT, production).

What if you want to pass a name of a linked server as a parameter to a stored procedure?
Or store it in a variable to modify and invoke dynamically?

What if your code base is huge and you can't use childish approaches from over the Internet?
Do you interact with hundreds of tables and views?

Are you tackle with any of this? Come here, I'll show something.

Here I stored a working & tested solution.

This technique will allow your team to preserve straightforward, standard and well-known development.
Of course, here you will look on things from another side, thanks for Microsoft.
But your dev & support will be happy.

To start using it, you need
1. Create two linked servers. By using names or by [MyServer/MyInstanfce].
1. Create an initial stored procedure to use the first linked server.
1. Install the [CloneSP](https://github.com/it3xl/linked-server-alias-workaround/blob/master/CloneSP.sql) stored procedure on your database.
1. Look at an example of usage in the [try-me-after-install-CloneSP.sql](https://github.com/it3xl/linked-server-alias-workaround/blob/master/try-me-after-install-CloneSP.sql)
1. During your database deployment process create a cloned stored procedure for the second linked server as the example shows in the [CloneSP](https://github.com/it3xl/linked-server-alias-workaround/blob/master/CloneSP.sql).

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

6. Use the cloned stored procedure where the first procedure is used.
1. Use your brain for others stuff. Or ask me if any troubles.

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
