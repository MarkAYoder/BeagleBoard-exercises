Array.make2DArray = function(length1, length2, argOp)
{
    var array1 = new Array(length1)
    for (var idx1 = 0; idx1 < length1; ++idx1)
    {
        var array2 = new Array(length2)
        for (var idx2 = 0; idx2 < length2; ++idx2)
            array2[idx2] = argOp(idx1, idx2)

        array1[idx1] = array2
    }

    return array1
}

/* delegate.stateDidChange(row, col, state, enabled): called as a result
 * of updating the board via click. Setting board state programmatically does
 * not call this method.
 */
BoardController = function(delegate, domContext, opts)
{
    this.delegate = delegate
    this.boardSize = (opts && opts.size) || 8
    this.installBoard(domContext)
}

BoardController.STATE_OFF = 0
BoardController.STATE_GREEN = 1 << 0
BoardController.STATE_RED = 1 << 1

BoardController.SVG_PARTS = {}
BoardController.SVG_PARTS[BoardController.STATE_GREEN] = 'green'
BoardController.SVG_PARTS[BoardController.STATE_RED] = 'red'
BoardController.CSS_CLASS_CELL_OFF = 'off'

BoardController.SVG_CONTENT = '\
<svg xmlns="http://www.w3.org/2000/svg" version="1.1" \
    viewBox="0 0 1 1" preserveAspectRatio="xMidYMid slice"> \
    <polygon points="0,0 1,0 0,1" class="green off" /> \
    <polygon points="1,1 1,0 0,1" class="red off" /> \
</svg>'

BoardController.prototype = {
    installBoard: function(domContext)
    {
        var delegateCallback = (function(row, col, state) {
            var newEnabled = this.toggleState(row, col, state) & state
            this.delegate && this.delegate.stateDidChange(row, col, state, newEnabled)
        }).bind(this)

        this.tableCells = Array.make2DArray(this.boardSize, this.boardSize, function(rowIdx, colIdx) {
            var cell = document.createElement('td')
            cell.innerHTML = BoardController.SVG_CONTENT
            cell.dataset.state = BoardController.STATE_OFF

            cell.querySelector('.green').addEventListener('click', function() {
                delegateCallback(rowIdx, colIdx, BoardController.STATE_GREEN)
            })
            cell.querySelector('.red').addEventListener('click', function() {
                delegateCallback(rowIdx, colIdx, BoardController.STATE_RED)
            })

            return cell
        })

        var table = this.table = document.createElement('table')
        domContext.appendChild(this.table)

        this.tableCells.forEach(function(cellsForRow) {
            var row = document.createElement('tr')
            cellsForRow.forEach(function(cell) { row.appendChild(cell) })
            table.appendChild(row)
        })
    },

    toggleState: function(row, col, state)
    {
        var newState = !this.getState(row, col, state)
        return this.setState(row, col, state, newState)
    },

    getState: function(row, col, state)
    {
        var rawState = this.tableCells[row][col].dataset.state
        return (state === undefined ? rawState : rawState & state)
    },

    setState: function(row, col, state, enabled)
    {
        var cell = this.tableCells[row][col],
            svgPartCssClass = BoardController.SVG_PARTS[state],
            svgPart = cell.querySelector('.' + svgPartCssClass)

        var oldState = cell.dataset.state,
            newState = (state === undefined ? enabled : (enabled ? oldState | state : oldState & ~state))

        if (newState & state)
        {
            svgPart.classList.remove(BoardController.CSS_CLASS_CELL_OFF)
            cell.classList.add(svgPartCssClass)
        }
        else
        {
            svgPart.classList.add(BoardController.CSS_CLASS_CELL_OFF)
            cell.classList.remove(svgPartCssClass)
        }

        return (cell.dataset.state = newState)
    },

    configureBoard: function(confOp)
    {
        for (var rowIdx = 0; rowIdx < this.boardSize; ++rowIdx)
            for (var colIdx = 0; colIdx < this.boardSize; ++colIdx)
            {
                this.setState(rowIdx, colIdx, BoardController.STATE_GREEN, confOp(rowIdx, colIdx, BoardController.STATE_GREEN))
                this.setState(rowIdx, colIdx, BoardController.STATE_RED, confOp(rowIdx, colIdx, BoardController.STATE_RED))
            }
    }
}

/* delegate.matrixDataDidChange(): Called whenver new matrix is sent
 *   from the server.
 */
MatrixIOController = function(delegate, websocketAddress)
{
    this.delegate = delegate
    this.i2cAddress = '0x70'
    this.fakeStatus = true;

    this.connect(websocketAddress)
}

MatrixIOController.COLOR_GREEN = 'green'
MatrixIOController.COLOR_RED = 'red'

MatrixIOController.prototype = {
    connect: function(websocketAddress)
    {
        this.socket = io.connect(websocketAddress)

        this.socket.on('message', function(data)
            { console.log('Received: message ' + data) })
        this.socket.on('connect', function()
            { console.log('Connected to Server') })
        this.socket.on('disconnect', function()
            { console.log('Disconnected from Server') })
        this.socket.on('reconnect', function()
            { console.log('Reconnected to Server') })
        this.socket.on('reconnecting', function(nextRetry)
            { console.log('Reconnecting in ' + nextRetry/1000 + ' s') })
        this.socket.on('reconnect_failed', function()
            { console.log('Reconnect Failed') })

        this.socket.on('matrix', (function(data) {
            this.matrixData = data.split(' ').map(function(row, idx) {
                return parseInt(row, 16)
            })

            this.delegate && this.delegate.matrixDataDidChange()
        }).bind(this))
        this.reloadMatrix()
    },

    reloadMatrix: function()
    {
        this.socket.emit("matrix", this.i2cAddress)
    },

    setMatrix: function(data)
    {
        this.matrixData = data

        for (var rowIdx = 0; rowIdx < this.matrixData.length; ++rowIdx)
            this.sendRowUpdate(rowIdx)
    },

    getMatrix: function()
    {
        return JSON.parse(JSON.stringify(this.matrixData))
    },

    getMatrixColorEnabledAtPoint: function(i, j, color)
    {
        var rowIdx = this.computeRowIndex(i, color),
            rowColorMask = this.matrixData[rowIdx],
            rowMask = 1 << j

        return rowColorMask & rowMask
    },

    setMatrixColorEnabledAtPoint: function(i, j, color, enabled)
    {
        var rowIdx = this.computeRowIndex(i, color),
            oldRowData = this.matrixData[rowIdx],
            rowColorMask = 1 << j,
            newRowData = (enabled ? oldRowData | rowColorMask : oldRowData & ~rowColorMask)

        this.matrixData[rowIdx] = newRowData
        this.sendRowUpdate(rowIdx)
    },

    sendRowUpdate: function(rowIdx)
    {
        var newRowData = this.matrixData[rowIdx],
            newRowHex = '0x' + newRowData.toString(16),
            i2cSetMessage = { i2cNum: this.i2cAddress, i: rowIdx, disp: newRowHex }

        this.socket.emit('i2cset', i2cSetMessage)
    },

    computeRowIndex: function(i, color)
    {
        return (color === MatrixIOController.COLOR_GREEN ? i * 2 : i * 2 + 1)
    }
}

function pseudoUUID()
{
    return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
        var r = Math.random()*16|0, v = c == 'x' ? r : (r&0x3|0x8);
        return v.toString(16);
    });
}

Snapshot = function(uuid)
{
    this.uuid = uuid || pseudoUUID()
}

Snapshot.allSnapshots = function()
{
    var numberOfSnapshots = localStorage.length,
        snapshots = []

    for (var idx = 0; idx < numberOfSnapshots; ++idx)
        snapshots.push(new Snapshot(localStorage.key(idx)))

    return snapshots
}

Snapshot.clearAllSnapshots = function()
{
    Snapshot.allSnapshots().forEach(function(snapshot) {
        snapshot.remove()
    })
}

Snapshot.prototype = {
    save: function(obj)
    {
        localStorage.setItem(this.uuid, JSON.stringify(obj))
    },

    get: function()
    {
        return JSON.parse(localStorage.getItem(this.uuid))
    },

    remove: function()
    {
        localStorage.removeItem(this.uuid)
    },
}