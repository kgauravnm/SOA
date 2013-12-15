
package com.example.componentservice;

import javax.xml.bind.JAXBElement;
import javax.xml.bind.annotation.XmlElementDecl;
import javax.xml.bind.annotation.XmlRegistry;
import javax.xml.namespace.QName;


/**
 * This object contains factory methods for each 
 * Java content interface and Java element interface 
 * generated in the com.example.componentservice package. 
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

    private final static QName _AddComponentResponse_QNAME = new QName("http://componentservice.example.com/", "addComponentResponse");
    private final static QName _GetComponent_QNAME = new QName("http://componentservice.example.com/", "getComponent");
    private final static QName _RegisterComponentResponse_QNAME = new QName("http://componentservice.example.com/", "registerComponentResponse");
    private final static QName _CheckInventoryResponse_QNAME = new QName("http://componentservice.example.com/", "checkInventoryResponse");
    private final static QName _GetComponentResponse_QNAME = new QName("http://componentservice.example.com/", "getComponentResponse");
    private final static QName _RegisterComponent_QNAME = new QName("http://componentservice.example.com/", "registerComponent");
    private final static QName _AddComponent_QNAME = new QName("http://componentservice.example.com/", "addComponent");
    private final static QName _CheckInventory_QNAME = new QName("http://componentservice.example.com/", "checkInventory");

    /**
     * Create a new ObjectFactory that can be used to create new instances of schema derived classes for package: com.example.componentservice
     * 
     */
    public ObjectFactory() {
    }

    /**
     * Create an instance of {@link CheckInventoryResponse }
     * 
     */
    public CheckInventoryResponse createCheckInventoryResponse() {
        return new CheckInventoryResponse();
    }

    /**
     * Create an instance of {@link RegisterComponent }
     * 
     */
    public RegisterComponent createRegisterComponent() {
        return new RegisterComponent();
    }

    /**
     * Create an instance of {@link GetComponentResponse }
     * 
     */
    public GetComponentResponse createGetComponentResponse() {
        return new GetComponentResponse();
    }

    /**
     * Create an instance of {@link AddComponentResponse }
     * 
     */
    public AddComponentResponse createAddComponentResponse() {
        return new AddComponentResponse();
    }

    /**
     * Create an instance of {@link RegisterComponentResponse }
     * 
     */
    public RegisterComponentResponse createRegisterComponentResponse() {
        return new RegisterComponentResponse();
    }

    /**
     * Create an instance of {@link GetComponent }
     * 
     */
    public GetComponent createGetComponent() {
        return new GetComponent();
    }

    /**
     * Create an instance of {@link AddComponent }
     * 
     */
    public AddComponent createAddComponent() {
        return new AddComponent();
    }

    /**
     * Create an instance of {@link CheckInventory }
     * 
     */
    public CheckInventory createCheckInventory() {
        return new CheckInventory();
    }

    /**
     * Create an instance of {@link Component }
     * 
     */
    public Component createComponent() {
        return new Component();
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link AddComponentResponse }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://componentservice.example.com/", name = "addComponentResponse")
    public JAXBElement<AddComponentResponse> createAddComponentResponse(AddComponentResponse value) {
        return new JAXBElement<AddComponentResponse>(_AddComponentResponse_QNAME, AddComponentResponse.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link GetComponent }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://componentservice.example.com/", name = "getComponent")
    public JAXBElement<GetComponent> createGetComponent(GetComponent value) {
        return new JAXBElement<GetComponent>(_GetComponent_QNAME, GetComponent.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link RegisterComponentResponse }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://componentservice.example.com/", name = "registerComponentResponse")
    public JAXBElement<RegisterComponentResponse> createRegisterComponentResponse(RegisterComponentResponse value) {
        return new JAXBElement<RegisterComponentResponse>(_RegisterComponentResponse_QNAME, RegisterComponentResponse.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link CheckInventoryResponse }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://componentservice.example.com/", name = "checkInventoryResponse")
    public JAXBElement<CheckInventoryResponse> createCheckInventoryResponse(CheckInventoryResponse value) {
        return new JAXBElement<CheckInventoryResponse>(_CheckInventoryResponse_QNAME, CheckInventoryResponse.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link GetComponentResponse }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://componentservice.example.com/", name = "getComponentResponse")
    public JAXBElement<GetComponentResponse> createGetComponentResponse(GetComponentResponse value) {
        return new JAXBElement<GetComponentResponse>(_GetComponentResponse_QNAME, GetComponentResponse.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link RegisterComponent }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://componentservice.example.com/", name = "registerComponent")
    public JAXBElement<RegisterComponent> createRegisterComponent(RegisterComponent value) {
        return new JAXBElement<RegisterComponent>(_RegisterComponent_QNAME, RegisterComponent.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link AddComponent }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://componentservice.example.com/", name = "addComponent")
    public JAXBElement<AddComponent> createAddComponent(AddComponent value) {
        return new JAXBElement<AddComponent>(_AddComponent_QNAME, AddComponent.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link CheckInventory }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://componentservice.example.com/", name = "checkInventory")
    public JAXBElement<CheckInventory> createCheckInventory(CheckInventory value) {
        return new JAXBElement<CheckInventory>(_CheckInventory_QNAME, CheckInventory.class, null, value);
    }

}
