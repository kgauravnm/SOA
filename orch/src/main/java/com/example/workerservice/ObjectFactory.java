
package com.example.workerservice;

import javax.xml.bind.JAXBElement;
import javax.xml.bind.annotation.XmlElementDecl;
import javax.xml.bind.annotation.XmlRegistry;
import javax.xml.namespace.QName;


/**
 * This object contains factory methods for each 
 * Java content interface and Java element interface 
 * generated in the com.example.workerservice package. 
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

    private final static QName _SetWorkingAt_QNAME = new QName("http://workerservice.example.com/", "setWorkingAt");
    private final static QName _RemoveWorkingAtResponse_QNAME = new QName("http://workerservice.example.com/", "removeWorkingAtResponse");
    private final static QName _RemoveWorkingAt_QNAME = new QName("http://workerservice.example.com/", "removeWorkingAt");
    private final static QName _CheckWorkingAt_QNAME = new QName("http://workerservice.example.com/", "checkWorkingAt");
    private final static QName _CheckWorkingAtResponse_QNAME = new QName("http://workerservice.example.com/", "checkWorkingAtResponse");
    private final static QName _SetWorkingAtResponse_QNAME = new QName("http://workerservice.example.com/", "setWorkingAtResponse");

    /**
     * Create a new ObjectFactory that can be used to create new instances of schema derived classes for package: com.example.workerservice
     * 
     */
    public ObjectFactory() {
    }

    /**
     * Create an instance of {@link CheckWorkingAt }
     * 
     */
    public CheckWorkingAt createCheckWorkingAt() {
        return new CheckWorkingAt();
    }

    /**
     * Create an instance of {@link RemoveWorkingAt }
     * 
     */
    public RemoveWorkingAt createRemoveWorkingAt() {
        return new RemoveWorkingAt();
    }

    /**
     * Create an instance of {@link RemoveWorkingAtResponse }
     * 
     */
    public RemoveWorkingAtResponse createRemoveWorkingAtResponse() {
        return new RemoveWorkingAtResponse();
    }

    /**
     * Create an instance of {@link SetWorkingAt }
     * 
     */
    public SetWorkingAt createSetWorkingAt() {
        return new SetWorkingAt();
    }

    /**
     * Create an instance of {@link SetWorkingAtResponse }
     * 
     */
    public SetWorkingAtResponse createSetWorkingAtResponse() {
        return new SetWorkingAtResponse();
    }

    /**
     * Create an instance of {@link CheckWorkingAtResponse }
     * 
     */
    public CheckWorkingAtResponse createCheckWorkingAtResponse() {
        return new CheckWorkingAtResponse();
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link SetWorkingAt }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://workerservice.example.com/", name = "setWorkingAt")
    public JAXBElement<SetWorkingAt> createSetWorkingAt(SetWorkingAt value) {
        return new JAXBElement<SetWorkingAt>(_SetWorkingAt_QNAME, SetWorkingAt.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link RemoveWorkingAtResponse }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://workerservice.example.com/", name = "removeWorkingAtResponse")
    public JAXBElement<RemoveWorkingAtResponse> createRemoveWorkingAtResponse(RemoveWorkingAtResponse value) {
        return new JAXBElement<RemoveWorkingAtResponse>(_RemoveWorkingAtResponse_QNAME, RemoveWorkingAtResponse.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link RemoveWorkingAt }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://workerservice.example.com/", name = "removeWorkingAt")
    public JAXBElement<RemoveWorkingAt> createRemoveWorkingAt(RemoveWorkingAt value) {
        return new JAXBElement<RemoveWorkingAt>(_RemoveWorkingAt_QNAME, RemoveWorkingAt.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link CheckWorkingAt }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://workerservice.example.com/", name = "checkWorkingAt")
    public JAXBElement<CheckWorkingAt> createCheckWorkingAt(CheckWorkingAt value) {
        return new JAXBElement<CheckWorkingAt>(_CheckWorkingAt_QNAME, CheckWorkingAt.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link CheckWorkingAtResponse }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://workerservice.example.com/", name = "checkWorkingAtResponse")
    public JAXBElement<CheckWorkingAtResponse> createCheckWorkingAtResponse(CheckWorkingAtResponse value) {
        return new JAXBElement<CheckWorkingAtResponse>(_CheckWorkingAtResponse_QNAME, CheckWorkingAtResponse.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link SetWorkingAtResponse }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://workerservice.example.com/", name = "setWorkingAtResponse")
    public JAXBElement<SetWorkingAtResponse> createSetWorkingAtResponse(SetWorkingAtResponse value) {
        return new JAXBElement<SetWorkingAtResponse>(_SetWorkingAtResponse_QNAME, SetWorkingAtResponse.class, null, value);
    }

}
