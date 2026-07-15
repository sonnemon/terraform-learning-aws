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
      body: JSON.stringify({ message: "users from lambda", users: [
        { id: 1, name: "John Doe" },
        { id: 2, name: "Jane Doe" },
        { id: 3, name: "John Smith" },
        { id: 4, name: "Jane Smith" },
      ] }),
    };
  };
  