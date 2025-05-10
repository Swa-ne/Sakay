const ManageAccountsIcon = ({ color = '#00A2FF' }: { color?: string }) => {
    return (
        <svg width='25' height='25' viewBox='0 0 10 10' fill='none' xmlns='http://www.w3.org/2000/svg'>
            <path d='M8.49609 2.22266L7.6582 3.06055L5.93945 1.3418L6.77734 0.503906C6.86328 0.417969 6.9707 0.375 7.09961 0.375C7.22852 0.375 7.33594 0.417969 7.42188 0.503906L8.49609 1.57812C8.58203 1.66406 8.625 1.77148 8.625 1.90039C8.625 2.0293 8.58203 2.13672 8.49609 2.22266ZM0.375 6.90625L5.44531 1.83594L7.16406 3.55469L2.09375 8.625H0.375V6.90625Z' fill={color} />
        </svg>
    );
};

export default ManageAccountsIcon;
