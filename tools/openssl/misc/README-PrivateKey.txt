PrivateKey.class - Program to extract private key from a keystore, given alias.

Example 1: Private key missing:

C:\cygwin\home\jcdc\Github\CW_Tools\tools\openssl\scripts>"C:\Program Files (x86)\Java\jdk1.6.0_45\bin\java.exe" PrivateKey ..\misc\example_keystores\bad_keystores\newjks 123456 cwkey
Exception in thread "main" java.lang.NullPointerException
        at PrivateKey.main(PrivateKey.java:29)


Exmaple 2: Private key present:

C:\cygwin\home\jcdc\Github\CW_Tools\tools\openssl\scripts>"C:\Program Files (x86)\Java\jdk1.6.0_45\bin\java.exe" Private
Key ..\misc\example_keystores\v811\cw\new-server.keystore 123456 cwkey
-----BEGIN PRIVATE KEY-----
MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCNjWsaUaWT9rHLNmBYR6tTMT1x
UMM13jwzEOBAsGf/hXTFraMW4UAVitUzQD/YuoZh1t01zMnMunIbh6/weHebsfo/fb4HeE1TQgrx
3m/+ZKOpMLwC7rHHIhp6jc+64egUdVeMfSgzcVHPQ1El4z4/JpaT4HdfFIXaavPNDdx3nLXJYzwf
LrQnAzYtKSAUrtfzbhbes9jMl1BM/dYQstu9xEKU26UZXpEFi1fXurxbG0lA5v/eVlVn2aZysNaX
rjcI71F2XDrAa//q5Za4Lfhu7Pjoat06OtfJQ0E3goneJp48/jLZlMeGbIOEuSEMfSOzLT7DBAUs
9XDtBl8bsV01AgMBAAECggEAP3oUdmf4tYKiNju7Nrtk89iX8hHCiIyROGEv/zJcYLSrKd50zVTT
lRV+CA6e0wTKMGPXLUIZmKpfc0MEvfR3xqUoUIKFzfm/yz9Jgy85z723uq51EWeS53a+owinB+o4
VbxNN14EwhTmF+jbIf9msZEPY178iPG+GLVvgRvfKu+7ZU6qP5xbGn9fgxuwvibjtS75Koj+WrQR
9yko/5+l5DVdlUFSH+j06HLaSdFjUYSMKfdfk9EcrIt490xQm3BpqNPO+YuPfGtdrzxlT4e7Hgad
WNdC1yvT7PwDwhEj+fSMOWgWFZ7MqT5PsfB8vw4jbWMpl8hgBIzlyBDOadX8PQKBgQDLeIH9zW3X
k9TeSG1nDOsrkVUJrnjqkQ3O5SEmEGkzvLJ7FUG2jAzFY8bZA0+cZe6ePjmgC+GZvunBVGfiAceT
g2jwHW93MqvrxIobtcgnOmLv1HdtDANpWWE/+ivJWXn0ClTyJ6RrVsUxoJpDC1ksKm1IwL1D3x1g
Br+wsOka2wKBgQCyGLHuOL+OuDcHIcs4cZgn3bTAw77HAISl1P9zYFFpvbUAxCNki7USxxhdX+pE
AOrwhIhFQK82cxPJmmJtK6WqGtToyaDknq9ue9OSHGPlLCCAZwUddaXCxHJ9/oAedD3PdEJQR/lH
BwJvThpDD891tqIFtv+ZSZ66oO73+4H9LwKBgQCc+A/YvCW0PQDopxl3eZjnmIvxFx+DXno3lb6X
/esbFcTffYufh7XGhe3+tzYwotaOT9Tm6qOVl5oAItytl8/etm87Zon6fCXzkkE1lWyfDsUK3m9v
uefb2y9SSu6CvDuAEIRt+DU49czVN2AqvtOBZg2/JaoddT/VN/+kEScUJwKBgHpAf2tSYxQaGhP4
O6LMPzEmfFxSQhQio+ud0Zimhlw6kBQtj0oGqM5yAqSeIZZ6tstRfqVjKKMMzYl3Q5dC/d5Nutbt
CVfGIhCKSYojmOMIrmrVzOoTBy0yYpFgcRv2mTNdz+OB9HiwNBipmVdtc/CO5JtdqgjUQ3RC4qcx
a2KbAoGAfTVa6oXo/ErJ0yvbu7uJrMC4E0l6aUuFTJmAQBfrU4LiEapP1RFq4TS1637j3oP3E4fb
+vQxJjhSO5566UKK3FxRuwc6NZxbjX4EElrT+QqjtAI1fJC4Y/nX3Kd6jPDDp++a9sPKFBiidH/Q
oQ0AwHKd0b+yhmghrNpDyusOrR4=
-----END PRIVATE KEY-----


JeremyC 30/7/2016
