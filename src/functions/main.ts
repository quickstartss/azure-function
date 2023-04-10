import { app, HttpRequest, HttpResponseInit, InvocationContext } from "@azure/functions";
import { createApp } from "../../../src/createApp";
import { configure } from "@vendia/serverless-express";

async function createHandler() {
    const app = await createApp()
    return configure({ app: app.getHttpAdapter().getInstance() })
}

let handler: any
export async function main(request: HttpRequest, context: InvocationContext): Promise<HttpResponseInit> {
    // @ts-ignore
    context.req = request;
    handler = handler || await createHandler();
    return handler(context, request);
};

app.http('main', {
    methods: ['GET', 'POST'],
    authLevel: 'anonymous',
    route: "{*any}",
    handler: main
});
