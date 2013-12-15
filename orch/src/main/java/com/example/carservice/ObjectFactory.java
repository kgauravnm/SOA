
package com.example.carservice;

import javax.xml.bind.JAXBElement;
import javax.xml.bind.annotation.XmlElementDecl;
import javax.xml.bind.annotation.XmlRegistry;
import javax.xml.namespace.QName;


/**
 * This object contains factory methods for each 
 * Java content interface and Java element interface 
 * generated in the com.example.carservice package. 
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

    private final static QName _GetInformationResponse_QNAME = new QName("http://carservice.example.com/", "getInformationResponse");
    private final static QName _AddCar_QNAME = new QName("http://carservice.example.com/", "addCar");
    private final static QName _GetInformation_QNAME = new QName("http://carservice.example.com/", "getInformation");
    private final static QName _AddCarResponse_QNAME = new QName("http://carservice.example.com/", "addCarResponse");
    private final static QName _NoSuchCarException_QNAME = new QName("http://carservice.example.com/", "NoSuchCarException");

    /**
     * Create a new ObjectFactory that can be used to create new instances of schema derived classes for package: com.example.carservice
     * 
     */
    public ObjectFactory() {
    }

    /**
     * Create an instance of {@link AddCarResponse }
     * 
     */
    public AddCarResponse createAddCarResponse() {
        return new AddCarResponse();
    }

    /**
     * Create an instance of {@link NoSuchCarException }
     * 
     */
    public NoSuchCarException createNoSuchCarException() {
        return new NoSuchCarException();
    }

    /**
     * Create an instance of {@link GetInformation }
     * 
     */
    public GetInformation createGetInformation() {
        return new GetInformation();
    }

    /**
     * Create an instance of {@link GetInformationResponse }
     * 
     */
    public GetInformationResponse createGetInformationResponse() {
        return new GetInformationResponse();
    }

    /**
     * Create an instance of {@link AddCar }
     * 
     */
    public AddCar createAddCar() {
        return new AddCar();
    }

    /**
     * Create an instance of {@link Car }
     * 
     */
    public Car createCar() {
        return new Car();
    }

    /**
     * Create an instance of {@link Manufacturer }
     * 
     */
    public Manufacturer createManufacturer() {
        return new Manufacturer();
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link GetInformationResponse }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://carservice.example.com/", name = "getInformationResponse")
    public JAXBElement<GetInformationResponse> createGetInformationResponse(GetInformationResponse value) {
        return new JAXBElement<GetInformationResponse>(_GetInformationResponse_QNAME, GetInformationResponse.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link AddCar }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://carservice.example.com/", name = "addCar")
    public JAXBElement<AddCar> createAddCar(AddCar value) {
        return new JAXBElement<AddCar>(_AddCar_QNAME, AddCar.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link GetInformation }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://carservice.example.com/", name = "getInformation")
    public JAXBElement<GetInformation> createGetInformation(GetInformation value) {
        return new JAXBElement<GetInformation>(_GetInformation_QNAME, GetInformation.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link AddCarResponse }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://carservice.example.com/", name = "addCarResponse")
    public JAXBElement<AddCarResponse> createAddCarResponse(AddCarResponse value) {
        return new JAXBElement<AddCarResponse>(_AddCarResponse_QNAME, AddCarResponse.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link NoSuchCarException }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://carservice.example.com/", name = "NoSuchCarException")
    public JAXBElement<NoSuchCarException> createNoSuchCarException(NoSuchCarException value) {
        return new JAXBElement<NoSuchCarException>(_NoSuchCarException_QNAME, NoSuchCarException.class, null, value);
    }

}
