package acme.service.soap.hotelws;

import javax.jws.WebMethod;
import javax.jws.WebParam;
import javax.jws.WebResult;
import javax.jws.WebService;
import javax.xml.bind.annotation.XmlSeeAlso;
import javax.xml.ws.RequestWrapper;
import javax.xml.ws.ResponseWrapper;

/**
 * This class was generated by Apache CXF 2.7.10
 * 2014-11-05T11:20:36.714Z
 * Generated source version: 2.7.10
 * 
 */
@WebService(targetNamespace = "http://soap.service.acme/HotelWS/", name = "HotelWS")
@XmlSeeAlso({ObjectFactory.class})
public interface HotelWS {

    @WebResult(name = "out", targetNamespace = "")
    @RequestWrapper(localName = "bookHotel", targetNamespace = "http://soap.service.acme/HotelWS/", className = "acme.service.soap.hotelws.BookHotel")
    @WebMethod
    @ResponseWrapper(localName = "bookHotelResponse", targetNamespace = "http://soap.service.acme/HotelWS/", className = "acme.service.soap.hotelws.BookHotelResponse")
    public java.lang.String bookHotel(
        @WebParam(name = "in", targetNamespace = "")
        java.lang.String in
    );

    @WebResult(name = "out", targetNamespace = "")
    @RequestWrapper(localName = "cancelBooking", targetNamespace = "http://soap.service.acme/HotelWS/", className = "acme.service.soap.hotelws.CancelBooking")
    @WebMethod
    @ResponseWrapper(localName = "cancelBookingResponse", targetNamespace = "http://soap.service.acme/HotelWS/", className = "acme.service.soap.hotelws.CancelBookingResponse")
    public int cancelBooking(
        @WebParam(name = "in", targetNamespace = "")
        java.lang.String in
    );

    @WebResult(name = "return", targetNamespace = "")
    @RequestWrapper(localName = "getAvailableHotel", targetNamespace = "http://soap.service.acme/HotelWS/", className = "acme.service.soap.hotelws.GetAvailableHotel")
    @WebMethod(action = "http://soap.service.acme/HotelWS/getAvailableHotel")
    @ResponseWrapper(localName = "getAvailableHotelResponse", targetNamespace = "http://soap.service.acme/HotelWS/", className = "acme.service.soap.hotelws.GetAvailableHotelResponse")
    public acme.service.soap.hotelws.Resort getAvailableHotel(
        @WebParam(name = "in", targetNamespace = "")
        acme.service.soap.hotelws.HotelRequest in
    );
}
