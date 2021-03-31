const OK = 200;
const Created = 201;
const Accepted = 202;
const NonAuthoritativeInformation = 203;
const NoContent = 204;
const ResetContent = 205;
const PartialContent = 206;
const MultipleChoices = 300;
const MovedPermanently = 301;
const Found = 302;
const SeeOther = 303;
const NotModified = 304;
const TemporaryRedirect = 307;
const PermanentRedirect = 308;
const BadRequest = 400;
const Unauthorized = 401;
const PaymentRequired = 402;
const Forbidden = 403;
const NotFound = 404;
const MethodNotAllowed = 405;
const NotAcceptable = 406;
const ProxyAuthenticationRequired = 407;
const RequestTimeout = 408;
const Conflict = 409;
const Gone = 410;
const LengthRequired = 411;
const PreconditionFailed = 412;
const PayloadTooLarge = 413;
const URITooLong = 414;
const UnsupportedMediaType = 415;
const RangeNotSatisfiable = 416;
const ExpectationFailed = 417;
const IMATeapot = 418;
const UnprocessableEntity = 422;
const TooEarly = 425;
const UpgradeRequired = 426;
const PreconditionRequired = 428;
const TooManyRequests = 429;
const RequestHeaderFieldsTooLarge = 431;
const UnavailableForLegalReasons = 451;
const InternalServerError = 500;
const NotImplemented = 501;
const BadGateway = 502;
const ServiceUnavailable = 503;
const GatewayTimeout = 504;
const HTTPVersionNotSupported = 505;
const VariantAlsoNegotiates = 506;
const InsufficientStorage = 507;
const LoopDetected = 508;
const NotExtended = 510;
const NetworkAuthenticationRequired = 511;

const sendError = (response, code, message) => {
    response.status(code).send(message);
}

const sendJson = (response, data, code = OK) => {
    response.status(code).json(data);
}

class CustomError extends Error {
    constructor(code, message) {
        super(message);
        this.code = code;
    }

}

module.exports = {
    CustomError,
    sendError,
    sendJson,
    OK,
    Created,
    Accepted,
    NonAuthoritativeInformation,
    NoContent,
    ResetContent,
    PartialContent,
    MultipleChoices,
    MovedPermanently,
    Found,
    SeeOther,
    NotModified,
    TemporaryRedirect,
    PermanentRedirect,
    BadRequest,
    Unauthorized,
    PaymentRequired,
    Forbidden,
    NotFound,
    MethodNotAllowed,
    NotAcceptable,
    ProxyAuthenticationRequired,
    RequestTimeout,
    Conflict,
    Gone,
    LengthRequired,
    PreconditionFailed,
    PayloadTooLarge,
    URITooLong,
    UnsupportedMediaType,
    RangeNotSatisfiable,
    ExpectationFailed,
    IMATeapot,
    UnprocessableEntity,
    TooEarly,
    UpgradeRequired,
    PreconditionRequired,
    TooManyRequests,
    RequestHeaderFieldsTooLarge,
    UnavailableForLegalReasons,
    InternalServerError,
    NotImplemented,
    BadGateway,
    ServiceUnavailable,
    GatewayTimeout,
    HTTPVersionNotSupported,
    VariantAlsoNegotiates,
    InsufficientStorage,
    LoopDetected,
    NotExtended,
    NetworkAuthenticationRequired,
};