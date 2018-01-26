IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.CloneSP') AND type in (N'P', N'PC'))
  DROP PROCEDURE dbo.CloneSP
GO



/*
  Creates a clone from an existing stored procedure with partially replaced SQL code.
*/
CREATE PROCEDURE dbo.CloneSP

  @source_name NVARCHAR(250),
  @target_name NVARCHAR(250),

  @sub1_from NVARCHAR(250),
  @sub1_to NVARCHAR(250),

  @sub2_from NVARCHAR(250),
  @sub2_to NVARCHAR(250)

AS
BEGIN

  PRINT ''
  PRINT '@@ Start: Generation of ' + @target_name + ' from ' + @source_name;
  PRINT ''
  PRINT 'ANSI_WARNINGS is ' + CONVERT(VARCHAR(10), SESSIONPROPERTY('ANSI_WARNINGS')) + '; ANSI_NULLS is ' + CONVERT(VARCHAR(10), SESSIONPROPERTY('ANSI_NULLS')) + '; QUOTED_IDENTIFIER is ' + CONVERT(VARCHAR(10), SESSIONPROPERTY('QUOTED_IDENTIFIER'));
  PRINT ''

  DECLARE @db_name NVARCHAR(250);
  SELECT @db_name = DB_NAME();

  WHILE 1 = 1
  BEGIN

    SET NOCOUNT ON;

    IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(@source_name) AND type in (N'P', N'PC'))
    BEGIN
      PRINT 'Interrupted. The "' + @source_name + '" stored procedure doesn''t exist.'
      BREAK;
    END;

    IF @target_name IS NULL OR RTRIM(LTRIM(@target_name)) = ''
    BEGIN
      PRINT 'Interrupted. Parameter "' + @target_name + '" is NULL or EMPTY.'
      BREAK;
    END;


    IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(@target_name) AND type in (N'P', N'PC'))
    BEGIN
      PRINT 'Dropping of existing ' + @target_name

      DECLARE @drop_target_sql NVARCHAR(500) = 'DROP PROCEDURE ' + @target_name;
      EXEC (@drop_target_sql);
    END;


    DECLARE @db_source_name NVARCHAR(500) = @db_name + N'.' + @source_name
    DECLARE @initial_sql NVARCHAR(MAX) = OBJECT_DEFINITION (OBJECT_ID(@db_source_name));
    --SET @initial_sql;

    DECLARE @result_sql NVARCHAR(MAX) = 
      REPLACE(
        REPLACE(@initial_sql, @sub1_from, @sub1_to),
        @sub2_from, @sub2_to)
    ;


    /*
    -- Debug. Outputs first sybols only.
    PRINT @result_sql;

    -- Debut. Outputs full SQL without line-breaks.
    DECLARE @t_od TABLE(line NVARCHAR(MAX));
    INSERT INTO @t_od SELECT @result_sql AS line;
    SELECT * FROM @t_od;
    */


    EXECUTE sp_executesql @result_sql;


    PRINT '';
    PRINT 'Successfully done'
    PRINT '';
    -- !!!
    -- !!! Deletion of the following BREAK instruction will destroy DB deployment, at all!
    -- !!!
    BREAK;
  END;
  PRINT '@@ End: Generation of ' + @target_name + ' from ' + @source_name;

END;
