'use client';

import React, { useState } from 'react';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { Plus } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { AccountTable } from '@/components/accountTable';
import { UnitsTable } from '@/components/unitTable';
import { StatisticCards } from '@/components/statisticsCard';
import { Role } from '@/types';
import useManageAccounts from '@/hooks/useManageAccounts';
import { Dialog, DialogTrigger } from '@/components/ui/dialog';
import AddDriverModal from '@/components/addDriverModal';
import AddUnitModal from '@/components/addUnitModal';

const ManageAccount = () => {
    const { accounts, units, assignDriverToUnit } = useManageAccounts();
    const [openDriverModal, setOpenDriverModal] = useState(false);
    const [openUnitModal, setOpenUnitModal] = useState(false);
    const tabs = [{ name: 'Accounts' }, { name: 'Units' }];
    const [filterRole, setFilterRole] = useState<Role | 'all'>('all');
    const [accountsPage, setAccountsPage] = useState(1);
    const [unitsPage, setUnitsPage] = useState(1);
    const itemsPerPage = 15;

    const filteredAccounts = accounts.filter((acc) => 
        filterRole === 'all' ? true : acc.role === filterRole
    );

    // Pagination for accounts
    const totalAccountPages = Math.ceil(filteredAccounts.length / itemsPerPage);
    const paginatedAccounts = filteredAccounts.slice(
        (accountsPage - 1) * itemsPerPage,
        accountsPage * itemsPerPage
    );

    // Pagination for units
    const totalUnitPages = Math.ceil(units.length / itemsPerPage);
    const paginatedUnits = units.slice(
        (unitsPage - 1) * itemsPerPage,
        unitsPage * itemsPerPage
    );

    const renderPagination = (currentPage: number, totalPages: number, setPage: (page: number) => void) => {
        if (totalPages <= 1) return null;

        const pagesToShow = [];
        const maxVisiblePages = 5;

        if (totalPages <= maxVisiblePages) {
            for (let i = 1; i <= totalPages; i++) {
                pagesToShow.push(i);
            }
        } else {
            // Always show first page
            pagesToShow.push(1);

            // Calculate start and end of middle pages
            let start = Math.max(2, currentPage - 1);
            let end = Math.min(totalPages - 1, currentPage + 1);

            // Adjust if we're near the start or end
            if (currentPage <= 3) {
                end = 4;
            } else if (currentPage >= totalPages - 2) {
                start = totalPages - 3;
            }

            // Add ellipsis if needed
            if (start > 2) {
                pagesToShow.push('...');
            }

            // Add middle pages
            for (let i = start; i <= end; i++) {
                pagesToShow.push(i);
            }

            // Add ellipsis if needed
            if (end < totalPages - 1) {
                pagesToShow.push('...');
            }

            // Always show last page
            pagesToShow.push(totalPages);
        }

        return (
            <div className="flex justify-center mt-10 w-full"> {/* Increased margin-top and full width */}
                <div className="flex items-center gap-1"> {/* Container for buttons */}
                    <Button
                        variant="outline"
                        size="sm"
                        onClick={() => setPage(Math.max(1, currentPage - 1))}
                        disabled={currentPage === 1}
                    >
                        Previous
                    </Button>
                    
                    {pagesToShow.map((page, index) => (
                        typeof page === 'number' ? (
                            <Button
                                key={index}
                                variant={currentPage === page ? "default" : "outline"}
                                size="sm"
                                onClick={() => setPage(page)}
                            >
                                {page}
                            </Button>
                        ) : (
                            <Button key={index} variant="outline" size="sm" disabled>
                                {page}
                            </Button>
                        )
                    ))}
                    
                    <Button
                        variant="outline"
                        size="sm"
                        onClick={() => setPage(Math.min(totalPages, currentPage + 1))}
                        disabled={currentPage === totalPages}
                    >
                        Next
                    </Button>
                </div>
            </div>
        );
    };

    return (
        <div className="p-4 md:p-5 w-full min-h-screen flex flex-col lg:flex-row gap-4 md:gap-5">
            {/* Left Panel (Statistics) - Full width on mobile, 1/4 on desktop */}
            <div className="w-full lg:w-1/4 rounded-2xl p-4 md:p-5 space-y-4 bg-background">
                <h2 className="text-xl md:text-2xl font-semibold">Account & Units Overview</h2>
                <StatisticCards accounts={accounts} units={units} />
            </div>

            {/* Right Panel (Tabs) - Full width on mobile, 3/4 on desktop */}
            <div className="w-full lg:w-3/4 bg-background rounded-2xl p-4 md:p-5 flex flex-col">
                <Tabs defaultValue={tabs[0].name} className="w-full flex flex-col flex-grow">
                    <TabsList className="p-0 bg-background justify-start border-b rounded-none space-x-2 mb-3 overflow-x-auto">
                        {tabs.map((tab) => (
                            <TabsTrigger 
                                key={tab.name} 
                                value={tab.name} 
                                className="rounded-none bg-background h-full data-[state=active]:shadow-none border-b-2 border-transparent data-[state=active]:border-b-primary whitespace-nowrap"
                            >
                                <code className="text-sm md:text-lg">{tab.name}</code>
                            </TabsTrigger>
                        ))}
                    </TabsList>

                    {/* Accounts Tab */}
                    <TabsContent value="Accounts" className="flex flex-col flex-grow">
                        <div className="flex flex-col sm:flex-row sm:space-x-3 sm:items-center justify-between mb-4 gap-2">
                            <div className="flex flex-wrap gap-2">
                                {['all', 'COMMUTER', 'DRIVER', 'ADMIN'].map((r) => (
                                    <Button 
                                        key={r} 
                                        onClick={() => {
                                            setFilterRole(r as Role | 'all');
                                            setAccountsPage(1); // Reset to first page when filter changes
                                        }} 
                                        className={`px-3 py-2 md:px-4 md:py-3 rounded text-sm md:text-base ${
                                            filterRole === r ? 'bg-primary text-white' : 'bg-gray-200'
                                        }`}
                                    >
                                        {r.charAt(0).toUpperCase() + r.slice(1)}
                                    </Button>
                                ))}
                            </div>
                            <Dialog open={openDriverModal} onOpenChange={setOpenDriverModal}>
                                <DialogTrigger asChild>
                                    <Button className="text-background px-3 py-2 md:px-4 md:py-3 text-sm md:text-base">
                                        Add Driver <Plus className="w-4 h-4" />
                                    </Button>
                                </DialogTrigger>
                                <AddDriverModal setOpen={setOpenDriverModal} />
                            </Dialog>
                        </div>
                        <div className="flex-grow overflow-x-auto">
                            <AccountTable 
                                filteredAccounts={paginatedAccounts} 
                                units={units} 
                                assignDriverToUnit={assignDriverToUnit} 
                            />
                        </div>
                        {renderPagination(accountsPage, totalAccountPages, setAccountsPage)}
                    </TabsContent>

                    {/* Units Tab */}
                    <TabsContent value="Units" className="flex flex-col flex-grow">
                        <div className="flex flex-col sm:flex-row sm:justify-between sm:items-center mb-4 gap-2">
                            <h3 className="text-lg md:text-xl font-semibold">Units List</h3>
                            <Dialog open={openUnitModal} onOpenChange={setOpenUnitModal}>
                                <DialogTrigger asChild>
                                    <Button className="text-background px-3 py-2 md:px-4 md:py-3 text-sm md:text-base">
                                        Add Unit <Plus className="w-4 h-4" />
                                    </Button>
                                </DialogTrigger>
                                <AddUnitModal setOpen={setOpenUnitModal} />
                            </Dialog>
                        </div>
                        <div className="flex-grow overflow-x-auto">
                            <UnitsTable units={paginatedUnits} drivers={accounts} />
                        </div>
                        {renderPagination(unitsPage, totalUnitPages, setUnitsPage)}
                    </TabsContent>
                </Tabs>
            </div>
        </div>
    );
};

export default ManageAccount;
