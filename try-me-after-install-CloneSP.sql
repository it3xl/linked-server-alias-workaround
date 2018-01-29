


-- !!! Please, run after installing CloneSP.sql !!! --




IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.MySampleSP') AND type in (N'P', N'PC')) DROP PROCEDURE dbo.MySampleSP
GO
CREATE PROCEDURE dbo.MySampleSP AS BEGIN
  PRINT '';
  PRINT 'SELECT tb.* FROM Server_level_alias__Linked_server.MyDb.dbo.MyTable AS tb;';
  SELECT '<Server_level_alias__Linked_server>' AS [Linked server alias];
END;
GO

EXEC MySampleSP;



-- Checking for existing of a target linked-server.
--IF EXISTS(SELECT * FROM sys.servers WHERE name = N'Replaced_alias__Other_linked_server')
--BEGIN

  -- ! Often must have ANSI_NULLS ON to create a cloned SP.
  SET ANSI_NULLS ON;

  EXECUTE CloneSP
    @source_name = '[dbo].[MySampleSP]',
    @target_name = '[dbo].[MyClonedSP]',

    @sub1_from = 'Server_level_alias__Linked_server',
    @sub1_to = 'Replaced_alias__Other_linked_server',

    @sub2_from = 'MySampleSP',
    @sub2_to = 'MyClonedSP'
  ;


  EXEC MyClonedSP;

--END;

