CREATE OR REPLACE FUNCTION show_user 
(OUT user_name name)
AS $$
	SELECT current_user 
$$
LANGUAGE sql;
