/****************************************************************************/
/* TITLE:  RmvDashAP                                                        */
/* DATE.:  08/22/24        Ian Sandoval                                     */
/* DESC.:  Take invoice numbers that are over a 15 digit limit and remove   */
/*         a character that isnt a number, check if length greater than 15, */   
/*         then remove second character that isnt a number and so on until  */
/*         all are gone or the number is less than 15 digits                */
/****************************************************************************/
/*   Modifications:                                                         */
/*   NO.     DATE    INIT   DESCRIPTION                                     */
/****************************************************************************/

CREATE OR REPLACE function RmvDashAP (
    INVOICE_NO VARCHAR(100)
)
 RETURNS CHAR(15)
  SPECIFIC RmvDashAP
  DETERMINISTIC
  NOT FENCED
  LANGUAGE SQL
BEGIN
    DECLARE RESULTOUT VARCHAR(100);
    DECLARE ERROR_MSG VARCHAR(100);
    DECLARE V_LENGTH INT;
    DECLARE V_RESULT VARCHAR(100);
    DECLARE V_POS INT;

    SET V_RESULT = INVOICE_NO;
    SET ERROR_MSG = '';

    -- Get length of return value
    SET V_LENGTH = LENGTH(V_RESULT);

    -- Loop when return lenth > 15 or when no more dashes
    WHILE V_LENGTH > 15 AND LOCATE('-', V_RESULT) > 0 DO
        -- Find Where the first dash is
        SET V_POS = locate('-', V_RESULT);

        -- Remove the first dash only
        SET V_RESULT = SUBSTR(V_RESULT, 1, V_POS - 1)
        || SUBSTR(V_RESULT, V_POS + 1);

        -- Get new length of return value
        SET V_LENGTH = LENGTH(V_RESULT);
    END WHILE;

    -- Loop when return lenth > 15  or when There are still forward slashes
    WHILE V_LENGTH > 15 AND LOCATE('/', V_RESULT) > 0 DO
        -- Find Where the first dash is
        SET V_POS = locate('/', V_RESULT);

        -- Remove the first dash only
        SET V_RESULT = SUBSTR(V_RESULT, 1, V_POS - 1)
        || SUBSTR(V_RESULT, V_POS + 1);

        -- Get new length of return value
        SET V_LENGTH = LENGTH(V_RESULT);
    END WHILE;

    -- Loop when return lenth > 15  or when There are still back slashes
    WHILE V_LENGTH > 15 AND LOCATE('\', V_RESULT) > 0 DO
        -- Find Where the first dash is
        SET V_POS = locate('\', V_RESULT);

        -- Remove the first dash only
        SET V_RESULT = SUBSTR(V_RESULT, 1, V_POS - 1)
        || SUBSTR(V_RESULT, V_POS + 1);

        -- Get new length of return value
        SET V_LENGTH = LENGTH(V_RESULT);
    END WHILE;
     -- Loop when return lenth > 15  or when There are still undercores
    WHILE V_LENGTH > 15 AND LOCATE('_', V_RESULT) > 0 DO
        -- Find Where the first dash is
        SET V_POS = locate('_', V_RESULT);

        -- Remove the first dash only
        SET V_RESULT = SUBSTR(V_RESULT, 1, V_POS - 1)
        || SUBSTR(V_RESULT, V_POS + 1);

        -- Get new length of return value
        SET V_LENGTH = LENGTH(V_RESULT);
    END WHILE;

     -- Loop when return lenth > 15 or when There are still alpha characters
    WHILE V_LENGTH > 15
      AND LENGTH(REGEXP_REPLACE(V_RESULT, '[A-Za-z]', '')) < V_LENGTH DO
        -- Find Where the first dash is
       SET V_RESULT = REGEXP_REPLACE(V_RESULT, '[A-Za-z]', '', 1, 1);
        -- Get new length of return value
        SET V_LENGTH = LENGTH(V_RESULT);
    END WHILE;

    -- If the length is still over 15 after taking out all
    --the dashes return an error
    if V_LENGTH > 15 Then
        set ERROR_MSG = 'Number too long';
        return ERROR_MSG;
    else
        SET RESULTOUT = V_RESULT;
        return RESULTOUT;
    END IF;
END;

LABEL ON SPECIFIC FUNCTION
RmvDashAP IS 'Remove first dash, check length then second dash';
 
