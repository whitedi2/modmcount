&Перед("ОбработкаЗаполнения")
Процедура УУ_ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ЗаказКлиента") Тогда 
		
		//+lud 17/10/22 Проверка повторного создания документов из заказа по обр. №7861 от 12.10.2022 {
		Отказ = сабОперОбщегоНазначения.ПроверкаСозданияНаОснованииНаСервере(ДанныеЗаполнения, "", СтандартнаяОбработка, ТипЗнч(Ссылка));
		Если Отказ.Приказ = "##УжеСоздан" Тогда
			ВызватьИсключение "На основании заказа уже введен документ " + Отказ.Ссылка;
		ИначеЕсли Отказ.Приказ = "##НеПроведен" Тогда
			ВызватьИсключение "Документ заказ клиента не проведен. Ввод на основании не возможен.";
		КонецЕсли;
		//} 
	КонецЕсли; 
	
КонецПроцедуры	

&Перед("ПриЗаписи")
Процедура УУ_ПриЗаписи(Отказ)
	
	сабОбщегоНазначения.сабПлатКалПриЗаписиОбъектовПриЗаписи(ЭтотОбъект, Отказ);

КонецПроцедуры
