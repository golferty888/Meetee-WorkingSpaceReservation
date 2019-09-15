export function fetchEach(collection) {
    const Bluebird = require('bluebird')
    const list = []
    collection.each(item => {
        // and convert to JSON right away
        list.push(item.fetch().then(b => b.toJSON()))
    })
    return Bluebird.all(list)
}