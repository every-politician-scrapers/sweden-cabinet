const fs = require('fs');
let rawmeta = fs.readFileSync('meta.json');
let meta = JSON.parse(rawmeta);

module.exports = (id, position, personname, positionname, startdate) => {
  reference = {
    P854: meta.source.url,
    P1476: {
      text: meta.source.title,
      language: meta.source.lang.code,
    },
    P813: new Date().toISOString().split('T')[0],
    P407: meta.source.lang.wikidata,
  }

  qualifier = {
    P580: meta.cabinet.start,
    P5054: meta.cabinet.id,
  }

  if(startdate)      qualifier['P580']  = startdate
  if(personname)     reference['P1810'] = personname
  if(positionname)   reference['P1932'] = positionname

  return {
    id,
    claims: {
      P39: {
        value: position,
        qualifiers: qualifier,
        references: reference,
      }
    }
  }
}
