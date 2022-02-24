
DELIMITER //
CREATE PROCEDURE curdemo()
BEGIN
  DECLARE done INT DEFAULT FALSE;
  DECLARE idp CHAR(10);
  DECLARE profesores CursoR FOR select idProfesor from Profesor;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
  OPEN profesores;
  read_loop: LOOP
    FETCH profesores INTO idp;
    IF done THEN
      LEAVE read_loop;
    END IF;
	select idp as "Para el profe";
    SELECT  distinct idEstudiante 
FROM (SELECT idEstudiante, idMateria -- T1
      FROM Curso_has_Estudiante) as T1
WHERE NOT EXISTS  -- T1 - T2
       (SELECT distinct idEstudiante -- T2
        FROM (SELECT * -- T1 X S
              FROM (SELECT idEstudiante
                    FROM Curso_has_Estudiante) as rT1 
			  CROSS JOIN (SELECT idMateria
                          FROM Curso
                          WHERE idprofesor=idp) as S) as T1XS
        WHERE NOT EXISTS ( -- (T1XS - R) 
                          SELECT *
                          FROM (SELECT idEstudiante, idmateria
                                FROM Curso_has_Estudiante) as R
                          WHERE T1XS.idEstudiante = R.idEstudiante
                          AND T1XS.idMateria = R.idMateria)
		AND T1XS.idEstudiante = T1.idEstudiante);
    
  END LOOP;
  CLOSE profesores;
END;




DELIMITER ;


DELIMITER;
