# How it works

## Architecture

IoT Assistant is a Ruby on Rails application which provides the web-based
interface for users and also sends printout information to the associated
printer. Only one printer can be associated with an instance of the IoT
Assistant (because as printouts are fetched by the printer they are
automatically removed from the queue as they are considered 'printed'). Future
versions of IoT Assistant may support a multiple printer deployment scenario
(it's on the roadmap).

When a user configures a scheduled print, or requests a print on demand, a
printout is constructed. This is in a machine-readable format (but also very 
human readable) and contains information for the printer telling it how
the text should be styled and what to print out.

The IoT Printer repeatedly polls a URL configured during deployment, and this
URL contains either the latest printout scheduled, or nothing (if no printouts
are scheduled). The URL for this is `/printer/:secret` where `:secret` is
defined in the configuration. This stops anyone guessing the URL if they know
you have the app deployed.

## Printer file format

The IoT Printer is loaded with a program to fetch + parse from a particular
endpoint. If the endpoint returns a blank file, it doesn't print anything,
otherwise it attempts to parse what it receives.

The code has very little error-handling, so you *must* make sure your output is
well formatted.

Each line *must* be of the following format (**the chevrons are not present in
the final file**):

    <s><j> <line>
    
where:

 - **s** is the **style** of the line. This can be one of:
   - **n** for normal text.
   - **b** for **bold** text.
   - **u** for _underlined_ text.
   - **i** for inverse (white on black) text.
 - **j** is the **justification** of the text. This can be one of:
   - **l** for left justification.
   - **c** for center justification.
   - **r** for right justification.

these two characters *must* then be followed by a space, and then the rest of
the text on the line will be printed. Unexpected behaviour may occur if there
is nothing in `<line>`. For blank lines, use something like `nl` followed by at
least 2 spaces.

 - **Do not omit the control characters**, you are likely to get unexpected
   results (e.g. missing letters on lines, wrongly formatted text, or missing
   lines entirely).
 - **Do not start lines with whitespace**, I don't know what happens if you do,
   but please fix the Arduino code so that it accepts it, because lack of
   indentation is a pain.
 - **The printer prints 32 characters per line** and will perform automatic
   line-breaks mid word. For optimum formatting, you should line-break your
   text in Ruby if possible.
