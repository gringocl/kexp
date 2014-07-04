keys     = %w[DefaultComments IsDeleted IsPurchasable LargeExtImage PlayCommentCount PlayUri ReleaseEventDate ReleaseImageUri TrackOpinionTally TrackPlayCount UpdatedDate]

fields   = Hash[ keys.map { |key| [key, ""] } ]

selector = { "PlayType" => { "$lte" => 5 } }

option   = { multi: true }

query    = {"$unset" =>  fields }

def remove_fields(collection, selector, query, options)
  collection.update(selector, query, options)
end
