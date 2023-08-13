-- Create the master key
CREATE MASTER KEY ENCRYPTION BY PASSWORD = '23987hxJ#KL95234nl0zBe';  

-- If the master key already exists, open it in the same session that you create the certificate (see next step)
OPEN MASTER KEY DECRYPTION BY PASSWORD = '23987hxJ#KL95234nl0zBe'

-- Create the certificate encrypted by the master key
CREATE CERTIFICATE MyCertificate
WITH SUBJECT = 'Backup Cert', EXPIRY_DATE = '20301231';

