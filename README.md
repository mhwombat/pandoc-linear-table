# pandoc-linear-table

## Usage

Use this filter by adding `--filter=pandoc-linear-table` to your pandoc command.
For example:

    pandoc --filter=pandoc-linear-table myfile.md --output=myfile.pdf

## Example

    ```{.linear-table}
    Each line of text in your markdown becomes a cell in the output table.
    The text will wrap automatically as needed to fit the table.
    Use a blank line to indicate the end of a row.

    ` `
    To leave a column blank, use ` `. See the previous cell for an example.
    I call these "linear tables" because it kind of looks like a table if you look at it sideways.

    You can include LaTex formulas and other markup. for example: $(\bigcap_{x \in \mathscr{C}} X)'$
    Here's an [example of a link](https://github.com/mhwombat/pandoc-linear-table)
    And an image: ![](https://github.com/)
    ```

Depending on your output format, the result of the above will look
like this:

![](table.png)
