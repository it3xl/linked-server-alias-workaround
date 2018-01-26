# linked-server-alias-workaround
SQL Server Linked Server's aliasing workaround. Permanent Scaffolding is the main idea.

Microsoft SQL server doesn't allow you to have a reference to a linked server or an alias.
This is an infamous feature and view of Microsoft, for decades. There are no aliases for server-level objects.

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
1. Install the [CloneSP](https://github.com/it3xl/linked-server-alias-workaround/blob/master/CloneSP.sql) stored procedure on your database.
2. Look at an example of usage in the [try-me-after-install-CloneSP.sql](https://github.com/it3xl/linked-server-alias-workaround/blob/master/try-me-after-install-CloneSP.sql)
3. During your database deployment process create a cloned stored procedure as the example shows by the [CloneSP](https://github.com/it3xl/linked-server-alias-workaround/blob/master/CloneSP.sql).
4. Use the cloned stored procedure where your original procedure is used.
5. Use your brain for others stuff. Or ask me if any troubles.
