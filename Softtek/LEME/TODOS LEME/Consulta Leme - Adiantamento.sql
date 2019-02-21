SELECT P.CODFIL,       
       P.TIPOPED,
       P.NUMPEDVEN,
       P.DTPEDIDO,
       CASE WHEN (P.DTENTREGA IS NULL OR P.DTENTREGA <TO_DATE('01/01/1900','DD/MM/RRRR')) THEN TO_DATE('01/01/1900','DD/MM/RRRR') ELSE P.DTENTREGA END  DTENTREGA,
       NVL(P.DTENTREGA_ORIGINAL,TO_DATE('01/01/1900','DD/MM/RRRR')) DTENTREGA_ORIGINAL,
       P.VLTOTITEMACUM,
       CAST(NVL(P.VLTOTAL,0) AS NUMBER(15, 2)) AS VLTOTAL_PEDIDO,
       CAST(SUM(NVL(L.VALLAN, 0)) AS NUMBER(15, 2)) AS VLTOTAL,
       P.STATUS,
       P.SITCARGA,
       NVL(P.DTCANCELA,TO_DATE('01/01/1900','DD/MM/RRRR')) DTCANCELA,       
       L.CODFILCXA,
       NVL(P.CODCLI, 0) CODCLI,
       NVL(L.DATENT,TO_DATE('01/01/1900','DD/MM/RRRR')) DATENT
  FROM MOV_PEDIDO P
 INNER JOIN CXA_LANCTO L ON L.NUMPED = P.NUMPEDVEN
                        AND L.CODFIL = P.CODFIL
 WHERE P.CODFIL  IN(&CODFIL, &CODDEP) AND L.DATENT = TO_DATE('&DATA','DD/MM/RRRR')
   AND L.CODOPER IS NOT NULL
   AND L.STATUS <> 9
   AND L.CODEVE <> 19
   AND (L.CODEVE NOT IN (31, 46) OR
       (L.CODEVE IN (31, 46) AND L.STATUS <> 2))
   AND L.STATUS = 2
 GROUP BY P.CODFIL,
          P.TIPOPED,
          P.NUMPEDVEN,
          P.DTPEDIDO,
          P.DTENTREGA,
          P.DTENTREGA_ORIGINAL,
          P.VLTOTITEMACUM,
          P.VLTOTAL,
          P.STATUS,
          P.SITCARGA,
          P.DTCANCELA,
          L.CODFILCXA,
          P.CODCLI,
          L.DATENT