# ImageMagick

## Converting multiple jpeg files to a single PDF document
`convert *.jpg out.pdf`

**NOTE:** If you see the following error...

        $ convert *.jpg out.pdf
        convert-im6.q16: not authorized `out.pdf' @ error/constitute.c/WriteImage/1037

...then you need to edit `/etc/ImageMagick.../policy.xml' as follows:

        $ diff -c /etc/ImageMagick-6/policy.xml.orig /etc/ImageMagick-6/policy.xml
        *** /etc/ImageMagick-6/policy.xml.orig  2019-09-29 20:51:11.211106113 +0100
        --- /etc/ImageMagick-6/policy.xml       2019-09-29 20:52:03.528763137 +0100
        ***************
        *** 71,78 ****
        --- 71,81 ----
            <policy domain="path" rights="none" pattern="@*"/>
            <policy domain="cache" name="shared-secret" value="passphrase" stealth="true"/>
            <!-- disable ghostscript format types -->
        +   <!--
            <policy domain="coder" rights="none" pattern="PS" />
            <policy domain="coder" rights="none" pattern="EPS" />
            <policy domain="coder" rights="none" pattern="PDF" />
            <policy domain="coder" rights="none" pattern="XPS" />
        +   -->
        +   <policy domain="coder" rights="read|write" pattern="PDF,PS" />
          </policymap>

([See here](https://cromwell-intl.com/open-source/pdf-not-authorized.html))


JeremyC 29-09-2019
