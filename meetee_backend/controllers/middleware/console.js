exports.req = (request, response, next) => {
  console.log("-------------------------------------------------------------");
  console.log({
    request: request.method + " " + request.url,
    body: JSON.stringify(request.body)
  });
  next();
};
