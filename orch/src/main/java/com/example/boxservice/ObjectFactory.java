
package com.example.boxservice;

import javax.xml.bind.JAXBElement;
import javax.xml.bind.annotation.XmlElementDecl;
import javax.xml.bind.annotation.XmlRegistry;
import javax.xml.namespace.QName;


/**
 * This object contains factory methods for each 
 * Java content interface and Java element interface 
 * generated in the com.example.boxservice package. 
 * <p>An ObjectFactory allows you to programatically 
 * construct new instances of the Java representation 
 * for XML content. The Java representation of XML 
 * content can consist of schema derived interfaces 
 * and classes representing the binding of schema 
 * type definitions, element declarations and model 
 * groups.  Factory methods for each of these are 
 * provided in this class.
 * 
 */
@XmlRegistry
public class ObjectFactory {

    private final static QName _CheckBoxFree_QNAME = new QName("http://boxservice.example.com/", "checkBoxFree");

    /**
     * Create a new ObjectFactory that can be used to create new instances of schema derived classes for package: com.example.boxservice
     * 
     */
    public ObjectFactory() {
    }

    /**
     * Create an instance of {@link CheckBoxFree }
     * 
     */
    public CheckBoxFree createCheckBoxFree() {
        return new CheckBoxFree();
    }

    /**
     * Create an instance of {@link CheckBoxFreeResponse }
     * 
     */
    public CheckBoxFreeResponse createCheckBoxFreeResponse() {
        return new CheckBoxFreeResponse();
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link CheckBoxFree }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://boxservice.example.com/", name = "checkBoxFree")
    public JAXBElement<CheckBoxFree> createCheckBoxFree(CheckBoxFree value) {
        return new JAXBElement<CheckBoxFree>(_CheckBoxFree_QNAME, CheckBoxFree.class, null, value);
    }

}
