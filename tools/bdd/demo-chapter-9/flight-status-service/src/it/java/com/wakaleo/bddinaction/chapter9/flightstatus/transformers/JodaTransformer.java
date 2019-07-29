package com.wakaleo.bddinaction.chapter9.flightstatus.transformers;

import cucumber.api.Transformer;
import cucumber.runtime.ParameterInfo;
import org.joda.time.LocalDate;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;

import java.util.Locale;

/**
* JeremyC 29-07-2019
*
* From https://static.javadoc.io/info.cukes/cucumber-core/1.2.5/cucumber/api/Transformer.html :
*
* "Allows transformation of a step definition argument to a custom type, giving you full control over how that type is instantiated. "
*
* NOTE: This web page mentioned above describes exactly why we are using it here - i.e. to
*       convert a date string value into a LocalDate instance.
*
* (I can only assume that Cucumber-JVM finds this class dynamically at run-time, by locking for
*  where the "Transformer" abstract class has been extended).
*/

public class JodaTransformer extends Transformer<LocalDate> {

    private String format;

    @Override
    public void setParameterInfoAndLocale(ParameterInfo parameterInfo, Locale locale) {
        super.setParameterInfoAndLocale(parameterInfo, locale);
        this.format = parameterInfo.getFormat();
    }

    public LocalDate transform(String value) {
        return  DateTimeFormat.forPattern(format).parseLocalDate(value);
    }
}
