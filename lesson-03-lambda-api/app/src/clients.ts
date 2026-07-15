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
      body: JSON.stringify({ message: "clients from lambda", clients: [
        { id: 1, name: "Client 1", email: "client1@example.com" },
        { id: 2, name: "Client 2", email: "client2@example.com" },
        { id: 3, name: "Client 3", email: "client3@example.com" },
        { id: 4, name: "Client 4", email: "client4@example.com" },
      ] }),
    };
  };
  