/**
 * Background Cloud Function.  Responds to 'call' and 'publish'
 *
 * @param {object} event The Cloud Functions event.
 * @param {object} event.data The event data.
 * @param {function} The callback function.
 */
exports.helloWorld = function helloWorld (event, callback) {
  console.log(event);
  if (event.data.data) {  // Called via pubsub
    console.log(Buffer.from(event.data.data, 'base64').toString());
        // See what happens
    // callback(new Error('Pubsub'));
  } else {
    // Everything is ok

  }
  callback();
};
