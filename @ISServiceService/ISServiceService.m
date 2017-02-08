function obj = ISServiceService

obj.endpoint = 'http://localhost:8080/ISearchServices/services/ISService';
obj.wsdl = 'http://localhost:8080/ISearchServices/services/ISService?wsdl';

obj = class(obj,'ISServiceService');
end
