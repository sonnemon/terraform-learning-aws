import type {
    APIGatewayProxyEventV2,
    APIGatewayProxyResultV2,
  } from "aws-lambda";
  
  export const handler = async (
    event: APIGatewayProxyEventV2
  ): Promise<APIGatewayProxyResultV2> => {
    // Anything logged here ends up in the CloudWatch log group
    console.log("incoming request:", event.requestContext.http.method, event.rawPath);
  
    return {
      statusCode: 200,
      headers: { "content-type": "application/json" },
      body: JSON.stringify({ message: "roles from lambda", roles: [
        { id: 1, name: "Admin" },
        { id: 2, name: "User" },
        { id: 3, name: "Guest" },
      ] }),
    };
  };
  