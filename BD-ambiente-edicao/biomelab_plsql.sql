-- ============================================================
--  TRIGGER — Garante que apenas 1 ambiente ATIVO por usuário
-- ============================================================
CREATE OR REPLACE TRIGGER trg_ambiente_ativo_unico
BEFORE INSERT OR UPDATE ON T_BIOMELAB_AMBIENTE
FOR EACH ROW
WHEN (NEW.st_ativo = 'ATIVO')
DECLARE
    v_count INTEGER;
BEGIN
    SELECT COUNT(*)
    INTO   v_count
    FROM   T_BIOMELAB_AMBIENTE
    WHERE  id_usuario = :NEW.id_usuario
      AND  st_ativo   = 'ATIVO'
      AND  id_ambiente <> NVL(:NEW.id_ambiente, -1);
 
    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(
            -20001,
            'Usuário já possui um ambiente ATIVO. Desative-o antes de ativar outro.'
        );
    END IF;
END;
/