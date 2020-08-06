/* tslint:disable */
/* eslint-disable */

import { ReaderFragment } from "relay-runtime";
import { FragmentRefs } from "relay-runtime";
export type OtherAuctions_salesConnection = {
    readonly edges: ReadonlyArray<{
        readonly node: {
            readonly " $fragmentRefs": FragmentRefs<"AuctionCard_sale">;
        } | null;
    } | null> | null;
    readonly " $refType": "OtherAuctions_salesConnection";
};
export type OtherAuctions_salesConnection$data = OtherAuctions_salesConnection;
export type OtherAuctions_salesConnection$key = {
    readonly " $data"?: OtherAuctions_salesConnection$data;
    readonly " $fragmentRefs": FragmentRefs<"OtherAuctions_salesConnection">;
};



const node: ReaderFragment = {
  "argumentDefinitions": [],
  "kind": "Fragment",
  "metadata": null,
  "name": "OtherAuctions_salesConnection",
  "selections": [
    {
      "alias": null,
      "args": null,
      "concreteType": "SaleEdge",
      "kind": "LinkedField",
      "name": "edges",
      "plural": true,
      "selections": [
        {
          "alias": null,
          "args": null,
          "concreteType": "Sale",
          "kind": "LinkedField",
          "name": "node",
          "plural": false,
          "selections": [
            {
              "args": null,
              "kind": "FragmentSpread",
              "name": "AuctionCard_sale"
            }
          ],
          "storageKey": null
        }
      ],
      "storageKey": null
    }
  ],
  "type": "SaleConnection"
};
(node as any).hash = 'c2907770ffe0232df7c5a03b3a42b7d9';
export default node;
