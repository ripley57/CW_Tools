This Java keystore was created by inserting the root, intermediate and root certs into a non-existent keystore. As we know, this (silently) creates a new keystore, but it will be missing the private key that corresponds to the server certificate. This then causes HTTPS connections to fail immediately (with no error in the catalina log), and it also causes the certutilexe -importpfx command (as run by the "CW Commander") to fail with the error "CRYPT_E_SELF_SIGNED". 

JeremyC 30/7/2016.
